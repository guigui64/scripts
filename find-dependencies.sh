#! /bin/bash

if [[ $# -ne 1 ]] ; then
    echo "Usage: find-dependencies.sh PROPERTIES_FILE"
    exit 1
fi

RED='\033[0;31m'
NC='\033[0m' # No Color

DEP_ROOT="/tools/simtg"
FILENAME="$1"
declare -a PLATFORMS=("Ubuntu_16.04/64bit" "centos_7.0.1406/64bit" "Windows_7/64bit")

# work on input properties file
#grep "=" $FILENAME > /tmp/find-dep.properties
#sed -i "s/\.version//g" /tmp/find-dep.properties
while IFS='=' read -r project version ; do
    PATH=$DEP_ROOT/$project/${project}_${version}
    if [[ $project == "jsynoptic" ]] ; then PATH=$DEP_ROOT/$project/${project}-${version}; fi
    if [[ -a $PATH ]] ; then
        echo "$PATH -> exists"
    else
        for platform in "${PLATFORMS[@]}" ; do
            PATH=$DEP_ROOT/$project/$platform/${project}_${version}
            if [[ -a $PATH ]] ; then
                echo "$PATH -> exists"
            else
                echo -e "$PATH -> ${RED}doesn't exist !${NC}"
            fi
        done
    fi
done < <(grep "=" $FILENAME | grep -v "astrium_jsynoptic" | sed "s/\.version//g")
