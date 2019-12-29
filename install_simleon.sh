#!/bin/bash

SIMTG='2.9.0'
EXTRAARGS='--cesium=git@simforge:cpu/cesium'
#EXTRAARGS='--cesium=ext/cesium4/delivery/cesium_999.0.0'
LLVM_DIR='/tools/dependencies/Ubuntu_16.04/64bit/llvm/3.4'
#LLVM_DIR='/tools/dependencies/Ubuntu_16.04/64bit/llvm/4.0'
TARGETS_TO_INSTALL='build.leon3.scoc3.generic.32,install.leon3.scoc3.generic.32'
#TARGETS_TO_INSTALL='build.leon2.juice,install.leon2.juice'

./waf distclean configure --binary-version --simtg=${SIMTG} --llvm-dir=${LLVM_DIR} ${EXTRAARGS}
./waf --build-command ${TARGETS_TO_INSTALL}
