#! /bin/bash

if [[ $# == 0 || ( $1 != "official" && $1 != "latest" ) ]]; then
    echo "Usage: $0 VERSION"
    echo "Where VERSION is either 'official' or 'latest'"
    exit -1
fi

OFFICIAL_VERSION=6.3.12
LATEST_VERSION=6.9.3

cd $HOME/rangedb/applications
# -h means file exists and is a symlink
# -d means file exists and is a directory
if [[ -h rangedb_$OFFICIAL_VERSION ]] ; then
    echo "rangedb_$OFFICIAL_VERSION is a symlink"
    rm -v rangedb_$OFFICIAL_VERSION
fi
if [[ -d rangedb_$OFFICIAL_VERSION ]] ; then
    mv -v rangedb_$OFFICIAL_VERSION rangedb_${OFFICIAL_VERSION}_real
fi

if [[ $1 == "official" ]] ; then
    ln -sfv rangedb_${OFFICIAL_VERSION}_real rangedb_$OFFICIAL_VERSION
elif [[ $1 == "latest" ]] ; then
    ln -sfv rangedb_$LATEST_VERSION rangedb_$OFFICIAL_VERSION
fi
