#!/bin/bash

PREVIOUS_DIR=$(pwd)

for git in $(find workspace* -name .git) ; do
    DIR=$(dirname $git)
    cd $DIR
    echo "### Updating $DIR ###"
    git pull
    cd ${PREVIOUS_DIR}
done

