#!/bin/bash
# This script should be sourced to set the environment used for cores etc.
# This is inspired by the /usr/local/bin/eclipseIASI-NG script

TARTGET="Ubuntu_16.04/64bit"
TARGET_DEP="Ubuntu_16.04/64bit"

# Dependencies Locations
export ACE_ROOT=/tools/dependencies/${TARGET_DEP}/ACE-TAO/6.1.0
export TAO_ROOT=/tools/dependencies/${TARGET_DEP}/ACE-TAO/6.1.0
export ZMQ_ROOT=/tools/dependencies/${TARGET_DEP}/zeromq/4.0.3
#export XERCESCROOT=/tools/dependencies/${TARGET_DEP}/xerces-c/2.8.0
export XERCESCROOT=/usr
export XERCES_ROOT=${XERCESCROOT}
export TSP_ROOT=/tools/dependencies/${TARGET_DEP}/tsp/0.8.3
export PYTHON_ROOT=/usr/bin
export JAVA_HOME=/usr/java/default

export SIMTG_INSTALL_ROOT=/tools/simtg
export MODELS_INSTALL_ROOT=/models
export PROJECTS_INSTALL_ROOT=/projects
export HYBRID_INSTALL_ROOT=/hybrid

# Export PATH
export PATH=${TAO_ROOT}/bin:${ACE_ROOT}/bin:${ZMQ_ROOT}/bin:${PATH}

# Export LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${TAO_ROOT}/lib:${ACE_ROOT}/lib:${XERCESCROOT}/lib:${TSP_ROOT}/lib:${ZMQ_ROOT}/lib:${LD_LIBRARY_PATH}

# Set Workspace
if [ ${WORKSPACE} ]
then
        export SIMTG_LOCAL_ROOT=`cd ${WORKSPACE}; pwd`
else
        export SIMTG_LOCAL_ROOT=${HOME}/workspace
fi

# Display the environment set
echo "SimTG environment :"
echo " Workspace used        = ${SIMTG_LOCAL_ROOT}"
echo " SIMTG_LOCAL_ROOT      = ${SIMTG_LOCAL_ROOT}"
echo " SIMTG_INSTALL_ROOT    = ${SIMTG_INSTALL_ROOT}"
echo " MODELS_INSTALL_ROOT   = ${MODELS_INSTALL_ROOT}"
echo " PROJECTS_INSTALL_ROOT = ${PROJECTS_INSTALL_ROOT}"
echo " ACE/TAO_ROOT          = ${ACE_ROOT}"
echo " TSP_ROOT              = ${TSP_ROOT}"
echo " ZMQ_ROOT              = ${ZMQ_ROOT}"
echo " JAVA_HOME             = ${JAVA_HOME}"
echo " "
