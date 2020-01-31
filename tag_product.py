#! /usr/bin/env python
import argparse
import datetime
import os
import re
import shlex
import shutil
import subprocess
import tempfile
import webbrowser
from distutils.util import strtobool
from os.path import expanduser

from redmine import Redmine


def execute(cmd, cwd=".", stdout=None, stderr=None):
    command = shlex.split(cmd)
    p = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd
    )
    (out, err) = p.communicate()
    if p.returncode != 0:
        if err:
            print(err)
        raise Exception


def replace(file_path, pattern, subst):
    fh, abs_path = tempfile.mkstemp()
    regex = re.compile(pattern)
    with open(abs_path, "w") as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(regex.sub(subst, line))
    os.close(fh)
    os.remove(file_path)
    shutil.move(abs_path, file_path)


def get_project(redmine, product):
    projects = redmine.project.all()
    for project in projects:
        if project.name == product or project.identifier == product:
            return project
    raise Exception("Project " + product + " not found")


def create_redmine_version(redmine, project, version):
    versions = project.versions
    for v in versions:
        if v.name == project.name + "_" + version:
            return v

    v = redmine.version.new()
    v.project_id = project.id
    v.name = project.name + "_" + version
    v.status = "open"
    v.due_date = datetime.date.today()
    v.save()

    return v


def create_redmine_issue(redmine, project, version):

    v = create_redmine_version(redmine, project, version)

    issue = redmine.issue.new()
    issue.project_id = project.id
    issue.subject = "Delivery of " + version
    issue.tracker_id = 4
    issue.fixed_version_id = v.id
    issue.save()

    return issue.id


def tag(product, version, options):
    try:
        temp_dir = tempfile.mkdtemp()

        print("Clone git@%s:%s/%s.git" % (options.repository, options.group, product))
        cmd = "git clone git@%s:%s/%s.git" % (
            options.repository,
            options.group,
            product,
        )
        execute(cmd, cwd=temp_dir)

        print("Checkout develop")
        cwd = os.path.join(temp_dir, product)
        cmd = "git checkout develop"
        execute(cmd, cwd=cwd)

        print("Create local release branch")
        cmd = "git checkout -b release_%s" % (version)
        execute(cmd, cwd=cwd)

        print(
            "Patching %s.version in %s to %s" % (product, options.properties, version)
        )
        replace(
            os.path.join(cwd, "%s" % (options.properties)),
            "%s.version=.*" % (product),
            "%s.version=%s" % (product, version),
        )

        print("Commit changes")
        cmd = 'git commit -m "Udpate version" %s' % (options.properties)
        execute(cmd, cwd=cwd)

        # redmine issue after git commit
        if not options.noredmine:
            redmine_url = "http://" + options.redminerepository + "/redmine"
            home = expanduser("~")
            redmine_key = (
                open(home + "/.redmine_apikey_" + options.redminerepository, "r")
                .read()
                .replace("\n", "")
            )

            redmine = Redmine(redmine_url, key=redmine_key)
            project = get_project(
                redmine, options.redmineid if options.redmineid is not None else product
            )

            issueid = create_redmine_issue(redmine, project, version)
        else:
            issueid = "XXXXX"

        print("Merge release branch in master")
        cmd = "git checkout master"
        execute(cmd, cwd=cwd)

        cmd = 'git merge --no-ff -X theirs release_%s -m "Version %s\n\nFixID #%s"' % (
            version,
            version,
            issueid,
        )
        execute(cmd, cwd=cwd)

        print("Tag master")
        cmd = "git tag %s_%s" % (product, version)
        execute(cmd, cwd=cwd)

        do_push = False
        if options.noconfirm:
            do_push = True
        else:
            while True:
                try:
                    do_push = strtobool(
                        raw_input(
                            "Do you really want to push the tag to origin ? (y/n) "
                        )
                    )
                except ValueError:
                    pass
                else:
                    break

        if do_push:
            cmd = "git push origin master --tags"
            execute(cmd, cwd=cwd)
            webbrowser.open(
                "http://"
                + options.repository
                + "/redmine/projects/"
                + project.identifier
                + "/issues"
            )
            print("Done")
        else:
            print("Operation cancelled")

        return 0
    except Exception as e:
        print("Error :")
        print(str(e))
        return -1
    finally:
        shutil.rmtree(temp_dir)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        version="1.0", description="Tag a product version automatically"
    )
    parser.add_argument("product", help="Product name")
    parser.add_argument("version", help="Product version")

    parser.add_argument(
        "-r",
        "--repository",
        help="Gitlab repositiory for the product",
        default="simforge.tls.fr.astrium.corp",
    )
    parser.add_argument(
        "-rr",
        "--redminerepository",
        help="Redmine repositiory for the product",
        default="simforge.tls.fr.astrium.corp",
    )
    parser.add_argument(
        "-g", "--group", help="Gitlab groupname for the product", default="simtg"
    )
    parser.add_argument(
        "-p",
        "--properties",
        help="versions.properties path",
        default="ant/versions.properties",
    )

    parser.add_argument(
        "--noconfirm",
        help="Skip confirmation prompt before pushing to origin",
        action="store_true",
        default=False,
    )
    parser.add_argument(
        "--noredmine",
        help="Skip redmine issue management",
        action="store_true",
        default=False,
    )

    parser.add_argument(
        "--redmineid", help="Redmine product id if different from product name"
    )

    results = parser.parse_args()

    tag(results.product, results.version, results)
