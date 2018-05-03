#! /bin/bash

usage() {
    echo "Usage: release.sh X Y Z"
    echo "OPTIONS (TO PUT BEFORE THE THREE PARAMETERS!!!)"
    echo "  --help                    : print this usage message"
    echo "  --no-branch               : do not branch"
    echo "  --no-push                 : do not push to repo at the end"
    echo "  --no-develop              : gitflow does not own a develop branch : only master and releases"
    echo "  --origin-name ORIGIN_NAME : set the origin name (default is 'origin')"
    echo "  --prefix PREFIX           : prefix to add to the versions.properties path"
    echo "                              default value is '' -> ant/versions.properties"
    echo "  --log                     : print the git log before and after"
    echo "  --cherry-pick CP_HASH     : commit hash to cherry-pick into the patch version"
}

ORIGIN="origin"

if [[ $# < 3 ]]; then
    usage
    exit 1
fi

# TODO parameters and usage
while [[ $1 == --* ]]; do
    case $1 in
        "--help")
            usage
            exit 0
            ;;
        "--no-branch")
            NO_BRANCH="True"
            ;;
        "--no-develop")
            NO_DEVELOP="True"
            ;;
        "--no-push")
            NO_PUSH="True"
            ;;
        "--origin-name")
            shift
            ORIGIN=$1
            ;;
        "--prefix")
            shift
            PREFIX="$1"
            ;;
        "--log")
            LOG="True"
            ;;
        "--cherry-pick")
            shift
            CP_HASH=$1
            ;;
        *)
            echo "Invalid option : $1"
            usage
            exit 1
            ;;
    esac
    shift
done

if [[ $NO_BRANCH == "True" && $NO_DEVELOP == "True" ]]; then
    echo "Impossible to have both --no-branch and --no-develop options set"
    usage
    exit 1
fi

PROJECT=`basename $PWD`
PREV_BRANCH=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
X=$1
Y=$2
Z=$3
VERSION=$X.$Y.$Z
BRANCH=release-$X.$Y.x
TAG=${PROJECT}_${VERSION}

if [[ $LOG == "True" ]]; then echo "--- BEFORE ---" ; git log --all --graph --decorate --oneline ; fi

if [[ $Z == '0' ]]; then
    # Release new version

    if [[ $NO_BRANCH != "True" ]]; then
        git checkout -b $BRANCH
    else
        git checkout master
        git merge develop --no-edit
    fi
    PATTERN="999\.0"
    if [[ $NO_BRANCH == "True" ]]; then
        PATTERN="$X\.$((Y-1))"
    fi
    sed -i "s/$PATTERN/$X.$Y/" ${PREFIX}ant/versions.properties
    git add ${PREFIX}ant/versions.properties
    git commit -m "Release $PROJECT $VERSION"
    if [[ $NO_BRANCH != "True" && $NO_DEVELOP != "True" ]]; then
        git checkout master
        git merge $BRANCH --no-edit --no-ff
        git checkout --theirs ${PREFIX}ant/versions.properties
        git add ${PREFIX}ant/versions.properties
        git commit --no-edit
    fi
    git tag $TAG
    if [[ $NO_PUSH != "True" ]]; then
        git push $ORIGIN master $TAG
        if [[ $NO_BRANCH != "True" ]]; then
            git push $ORIGIN $BRANCH
        fi
    fi

else
    # Release patched version

    git checkout $BRANCH
    if [[ -n $CP_HASH ]]; then
        git cherry-pick $CP_HASH
        git commit --amend
    fi
    PATTERN="$X\.$Y\.$((Z-1))"
    sed -i "s/$PATTERN/$X.$Y.$Z/" ${PREFIX}ant/versions.properties
    git add "${PREFIX}"ant/versions.properties
    git commit -m "Release $PROJECT $VERSION"
    git tag $TAG
    if [[ $NO_PUSH != "True" ]]; then
        git push $ORIGIN $TAG $BRANCH
    fi

fi

git checkout $PREV_BRANCH

if [[ $LOG == "True" ]]; then echo "--- AFTER ---" ; git log --all --graph --decorate --oneline ; fi

