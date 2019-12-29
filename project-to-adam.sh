#! /bin/bash

if [[ $# < 2 ]]; then
    echo "Usage $0 PROJECT VERSION"
    exit 1
fi

PROJECT=$1
VERSION=$2

HOST="frene.astrium.eads.net"
FOLDER="from_AirbusDS/projects"
LIST_FILE="list.txt"
PROJECT_ROOT="/projects/JUICE"
declare -a PLATFORMS=("Ubuntu_16.04/64bit" "Windows_7/64bit")

ftpGet() {
    ftp -n $HOST << END_SCRIPT
user juice_rts abTJ\$EWONhys
cd $FOLDER
get $1
quit
END_SCRIPT
}

ftpPut() {
    ftp -n $HOST << END_SCRIPT
user juice_rts abTJ\$EWONhys
cd $FOLDER
put $1
quit
END_SCRIPT
}

archiveAndMove() {
    project=$1
    version=$2
    echo "### ${project} ${version} ###"
    if grep -q "${project}_${version}" $LIST_FILE; then
        echo "${project}_${version} has already been shared"
    else
        tar_name=${project}_${version}.tar
        tar cvf ${tar_name} --files-from /dev/null
        for platform in "${PLATFORMS[@]}"; do
            echo "Taring ${project}/${platform}/${project}_${version}..."
            if [[ $project == "dycemo" ]]; then
                tar rf ${tar_name} -C /models ${project}/${platform}/${project}_${version}
            else
                tar rf ${tar_name} -C ${PROJECT_ROOT} ${project}/${platform}/${project}_${version}
            fi
        done
        echo "bzip2 & mv to FTP"
        bzip2 ${tar_name}
        ftpPut ${tar_name}.bz2
        rm ${tar_name}.bz2
        echo "${project}_${version}" >> $LIST_FILE
    fi
}

ftpGet $LIST_FILE

if [[ $PROJECT == "cdmu_ruag" ]]; then
    declare -a projects=("cdmu_ruag cdmu_cole cdmu_ttrm")
    for sub_project in ${projects[@]}; do
        archiveAndMove $sub_project $VERSION
    done
elif [[ $PROJECT == "cdmu_cole" || $PROJECT == "cdmu_ttrm" ]]; then
    echo "Skipping $PROJECT"
elif [[ $PROJECT == "obc_common" ]]; then
    declare -a projects=("obc_common obc_tmtc obc_spw")
    for sub_project in ${projects[@]}; do
        archiveAndMove $sub_project $VERSION
    done
elif [[ $PROJECT == "obc_tmtc" || $PROJECT == "obc_spw" ]]; then
    echo "Skipping $PROJECT"
else
    archiveAndMove $PROJECT $VERSION
fi

ftpPut $LIST_FILE
rm $LIST_FILE
