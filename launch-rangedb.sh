#! /bin/bash

RANGE_PATH="/home/comte/rangedb/"
L_RANGEDB="./RangeDB"

# Load env
. ~/scripts/envSimTG.sh

# GTK fix for eclipse mars
export SWT_GTK3=0
export QT_GRAPHICSSYSTEM=native

THEME_FILE=""
#THEME_FILE=/home/comte/gtkrc-solarized-light

# Go to range dir
cd $RANGE_PATH
# Launch
GTK2_RC_FILES=$THEME_FILE $L_RANGEDB &>/tmp/range.log &
