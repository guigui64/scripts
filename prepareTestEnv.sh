#!/bin/bash

function usage() {
    echo "Usage : ./prepareTestEnv.sh \"path\""
}

if [ "$#" -ne 1 ]; then
    usage
else

    testpath=$1
    export SIMTG_LIB_PATH=$testpath
    export PATH=$testpath:$PATH
    export LD_LIBRARY_PATH=$testpath:$LD_LIBRARY_PATH

fi
