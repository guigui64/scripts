#!/bin/bash

PROJECT=$1
HOST="frene.astrium.eads.net"
FOLDER="from_AirbusDS/bundles"
TMP_FOLDER="/tmp/bundles"

ftpPut() {
    ftp -n $HOST <<END_SCRIPT
user juice_rts abTJ\$EWONhys
cd $FOLDER
put $1 $2
quit
END_SCRIPT
}

if [[ ! -d $TMP_FOLDER ]] ; then mkdir -p $TMP_FOLDER ; fi
cd $PROJECT
git bundle create $TMP_FOLDER/$PROJECT.bundle --all

ftpPut $TMP_FOLDER/$PROJECT.bundle $PROJECT.bundle
