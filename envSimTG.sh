#!/bin/bash
# This script should be sourced to set the environment used for cores etc.
# This is inspired by the /usr/local/bin/eclipseIASI-NG script

TARGET_DEP="Ubuntu_18.04/64bit"
GEN_TARGET_DEP="Linux/64bit"

# Dependencies Locations
DEPS_CACHE=${HOME}/tmp/DEPS_CACHE
# ACE-TAO
if [ ! -e ${DEPS_CACHE}/${TARGET_DEP}/ACE-TAO/6.4.8 ] ; then
	echo "Caching ACE-TAO 6.4.8..."
	mkdir -p ${DEPS_CACHE}/${TARGET_DEP}/ACE-TAO
	rsync --info=progress2 -az ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/ACE-TAO/6.4.8 ${DEPS_CACHE}/${TARGET_DEP}/ACE-TAO/
fi
export ACE_ROOT=${DEPS_CACHE}/${TARGET_DEP}/ACE-TAO/6.4.8
export TAO_ROOT=${ACE_ROOT}
# XERCES
# if [ ! -e ${DEPS_CACHE}/${TARGET_DEP}/xerces-c/2.8.0 ] ; then
# 	echo "Caching xerces-c 2.8.0..."
# 	mkdir -p ${DEPS_CACHE}/${TARGET_DEP}/xerces-c
# 	rsync --info=progress2 -az ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/xerces-c/2.8.0 ${DEPS_CACHE}/${TARGET_DEP}/xerces-c/
# fi
if [ ! -e ${DEPS_CACHE}/${TARGET_DEP}/xerces-c/3.1.2 ] ; then
	echo "Caching xerces-c 3.1.2..."
	mkdir -p ${DEPS_CACHE}/${TARGET_DEP}/xerces-c
	rsync --info=progress2 -az ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/xerces-c/3.1.2 ${DEPS_CACHE}/${TARGET_DEP}/xerces-c/
fi
export XERCESCROOT=${DEPS_CACHE}/${TARGET_DEP}/xerces-c/3.1.2
export XERCES_ROOT=${XERCESCROOT}
# ZMQ
if [ ! -e ${DEPS_CACHE}/${TARGET_DEP}/zeromq/4.0.3 ] ; then
	echo "Caching zeromq 4.0.3..."
	mkdir -p ${DEPS_CACHE}/${TARGET_DEP}/zeromq
	rsync --info=progress2 -az ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/zeromq/4.0.3 ${DEPS_CACHE}/${TARGET_DEP}/zeromq/
fi
export ZMQ_ROOT=${DEPS_CACHE}/${TARGET_DEP}/zeromq/4.0.3
# XSD
if [ ! -e ${DEPS_CACHE}/${GEN_TARGET_DEP}/xsd/4.0.0 ] ; then
	echo "Caching xsd 4.0.0..."
	mkdir -p ${DEPS_CACHE}/${GEN_TARGET_DEP}/xsd
	rsync --info=progress2 -az ${SDK_PATH}/tools/dependencies/${GEN_TARGET_DEP}/xsd/4.0.0 ${DEPS_CACHE}/${GEN_TARGET_DEP}/xsd
fi
export XSD_ROOT=${DEPS_CACHE}/${GEN_TARGET_DEP}/xsd/4.0.0
# PROTOBUF
if [ ! -e ${DEPS_CACHE}/${TARGET_DEP}/protobuf/3.0.0 ] ; then
	echo "Caching protobuf 3.0.0..."
	mkdir -p ${DEPS_CACHE}/${TARGET_DEP}/protobuf
	rsync --info=progress2 -az ${SDK_PATH}/tools/dependencies/${TARGET_DEP}/protobuf/3.0.0 ${DEPS_CACHE}/${TARGET_DEP}/protobuf
fi
export PROTOBUF_ROOT=${DEPS_CACHE}/${TARGET_DEP}/protobuf/3.0.0

# PYTHON
export PYTHON_ROOT=/usr/bin

export SIMTG_INSTALL_ROOT=/tools/simtg
export MODELS_INSTALL_ROOT=/models
export PROJECTS_INSTALL_ROOT=/projects
export HYBRID_INSTALL_ROOT=/hybrid

# Export PATH
export PATH=${TAO_ROOT}/bin:${ACE_ROOT}/bin:${ZMQ_ROOT}/bin:${PATH}

# Export LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${TAO_ROOT}/lib:${ACE_ROOT}/lib:${XERCESCROOT}/lib:${XSD_ROOT}/lib:${PROTOBUF_ROOT}/lib:${ZMQ_ROOT}/lib:${LD_LIBRARY_PATH}

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
echo " XSD_ROOT              = ${XSD_ROOT}"
echo " XERCES_ROOT           = ${XERCES_ROOT}"
echo " PROTOBUF_ROOT         = ${PROTOBUF_ROOT}"
echo " ZMQ_ROOT              = ${ZMQ_ROOT}"
echo " JAVA_HOME             = ${JAVA_HOME}"
echo " "
