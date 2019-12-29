#! /bin/bash

if [[ $# -ne 1 ]] ; then
    echo "Usage: juice-ftp-get-bundle.sh PROJECT_NAME"
    exit 1
fi

PROJECT_NAME="$1"
HOST="frene.astrium.eads.net"
FILE="$1.bundle"

ftp -nv $HOST <<END_SCRIPT
user njuiastri astri@polska
cd to_AirbusDS
cd code_review
cd $PROJECT_NAME
get $FILE
quit
END_SCRIPT

exit 0
