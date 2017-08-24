#! /bin/bash

if [[ $# -ne 1 ]] ; then
    echo "Usage: juice-code-review-update.sh PROJECT_NAME"
    exit 1
fi

PROJECT_NAME="$1"
HOST="frene.astrium.eads.net"
FILE="$1.bundle"

echo "### 1) retrieve the bundle on the ftp"
ftp $HOST <<END_SCRIPT
cd to_AirbusDS
cd code_review
cd $PROJECT_NAME
get $FILE
quit
END_SCRIPT

echo ""
echo "### 2) stash and pull"
cd $PROJECT_NAME
git stash save "juice-code-review-update script : stash changes before pulling the new bundle"
git checkout master
git pull

echo ""
echo "### 3) push"
git push haribo --all
git push haribo --tags

exit 0
