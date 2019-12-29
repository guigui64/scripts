#!/bin/bash

ROOT_FOLDER=$(\git rev-parse --show-toplevel)
CURR_DIR=$(pwd)
if [ "$ROOT_FOLDER" != "$CURR_DIR" ]
then
  echo "Switch to the root of the repo and try again. Should be in $ROOT_FOLDER"
  exit
fi

FILENAME=$1
TAGS=$(\git tag --sort=-v:refname)
for TAG in $TAGS; do
    echo "====================================================="
    echo "VERSION = $TAG"
    echo "====================================================="
    HASH=$(\git rev-parse $TAG)
    git show $HASH:$FILENAME
    echo ""
done
