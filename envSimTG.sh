#!/bin/bash
# This script should be sourced to set the environment used for cores etc.
# This is inspired by the /usr/local/bin/eclipseIASI-NG script

TARTGET="Ubuntu_16.04/64bit"
TARGET_DEP="Ubuntu_16.04/64bit"

# Dependencies Locations
DEPS_CACHE=${HOME}/tmp/DEPS_CACHE
# export ACE_ROOT=${SDK_PATH}/tools/dependencies/${TARGET_DEP}/ACE-TAO/6.1.0
if [ ! -e ${DEPS_CACHE}/ACE-TAO/6.1.0 ] ; then
    echo "Caching ACE-TAO 6.1.0..."
    mkdir -p ${DEPS_CACHE}/ACE-TAO
    cp -r ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/ACE-TAO/6.1.0/ ${DEPS_CACHE}/ACE-TAO/
fi
export ACE_ROOT=${DEPS_CACHE}/ACE-TAO/6.1.0
export TAO_ROOT=${ACE_ROOT}
# export XERCESCROOT=${SDK_PATH}/tools/dependencies/${TARGET_DEP}/xerces-c/2.8.0
if [ ! -e ${DEPS_CACHE}/xerces-c/2.8.0 ] ; then
    echo "Caching xerces-c 2.8.0..."
    mkdir -p ${DEPS_CACHE}/xerces-c
    cp -r ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/xerces-c/2.8.0/ ${DEPS_CACHE}/xerces-c/
fi
export XERCESCROOT=${DEPS_CACHE}/xerces-c/2.8.0
export XERCES_ROOT=${XERCESCROOT}
# export ZMQ_ROOT=${SDK_PATH}/tools/dependencies/${TARGET_DEP}/zeromq/4.0.3
if [ ! -e ${DEPS_CACHE}/zeromq/4.0.3 ] ; then
    echo "Caching zeromq 4.0.3..."
    mkdir -p ${DEPS_CACHE}/zeromq
    cp -r ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/zeromq/4.0.3/ ${DEPS_CACHE}/zeromq/
fi
export ZMQ_ROOT=${DEPS_CACHE}/zeromq/4.0.3
# export TSP_ROOT=${SDK_PATH}/tools/dependencies/${TARGET_DEP}/tsp/0.8.3
if [ ! -e ${DEPS_CACHE}/tsp/0.8.3 ] ; then
    echo "Caching tsp 0.8.3..."
    mkdir -p ${DEPS_CACHE}/tsp
    cp -r ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/tsp/0.8.3/ ${DEPS_CACHE}/tsp/
fi
export TSP_ROOT=${DEPS_CACHE}/tsp/0.8.3
export PYTHON_ROOT=/usr/bin

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
