#! /bin/bash

if [[ $# != 1 ]]; then
    echo "Usage: release-new-obc.sh VERSION_NB"
    echo "To release 3.46.0 for instance, run release-new-obc.sh 46"
    exit 1
fi

VERSION=$1

git checkout -b release-3.$VERSION.x
sed -i "s/999\.0/3.$VERSION/" **/ant/versions.properties
git add **/ant/versions.properties
git commit -m "Release OBC 3.$VERSION.0"
git checkout master
git merge release-3.$VERSION.x
git checkout --theirs **/ant/versions.properties
git add **/ant/versions.properties
git commit --no-edit
git tag obc_3.$VERSION.0
git log --graph --decorate --oneline --all
git push origin master release-3.$VERSION.x obc_3.$VERSION.0
git checkout develop
