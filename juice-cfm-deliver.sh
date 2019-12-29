#! /bin/bash

if [[ $# -ne 2 ]] ; then
    echo "Usage: juice-cfm-deliver.sh PROJECT_NAME VERSION"
    exit 1
fi

INSTALL_ROOT="/projects/JUICE"
PROJECT_NAME="$1"
VERSION="$2"
declare -a PLATFORMS=("Ubuntu_16.04/64bit" "centos_7.0.1406/64bit" "Windows_7/64bit")

FOLDER="${PROJECT_NAME}_${VERSION}"
TAR_NAME="$FOLDER.tar"
# Create empty archive
tar cvf $TAR_NAME --files-from /dev/null

# Append each platform
for platform in "${PLATFORMS[@]}"
do
    if [[ -a $INSTALL_ROOT/$PROJECT_NAME/$platform/$FOLDER ]]
    then
        tar rf $TAR_NAME -C $INSTALL_ROOT $PROJECT_NAME/$platform/$FOLDER
    else
        echo "WARNING : $FOLDER doesn't exist for platform $platform in $INSTALL_ROOT"
    fi
done

if [[ -a $TAR_NAME.bz2 ]]
then
    rm $TAR_NAME.bz2
fi
bzip2 $TAR_NAME
