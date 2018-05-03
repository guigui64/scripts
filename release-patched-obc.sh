#! /bin/bash

if [[ $# < 3 ]]; then
    echo "Usage: release-new-obc.sh X.Y Z HASH [--no-push]"
    echo "To release X.Y.Z by cherry-picking commit HASH"
    exit 1
fi

BRANCH=release-$1.x
VERSION=$1.$2
HASH=$3

git checkout $BRANCH
git cherry-pick $HASH
git commit --amend
sed -i "s/$1\.$(($2 - 1))/$VERSION/" **/ant/versions.properties
git add **/ant/versions.properties
git commit -m "Release OBC $VERSION"
git tag obc_$VERSION
git log --oneline --decorate --graph --all

if [[ $4 != '--no-push' ]]; then
    git push origin $BRANCH obc_$VERSION
    git checkout develop
fi
