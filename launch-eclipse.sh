#! /bin/bash

# Usage
function usage {
    echo "Usage : launch-eclipse.sh [-h] [-c] [-t theme] [-v local|<VERSION>] [-w <WORKSPACE>]"
}

# Read opts
CLEAN=0
THEME=""
VERSION="local"
WORKSPACE="/home/comte/workspace"
OPTIND=1
while getopts "hct:v:w:" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        c)
            CLEAN=1
            ;;
        t)
            THEME=$OPTARG
            ;;
        v)
            VERSION=$OPTARG
            ;;
        w)
            WORKSPACE=$OPTARG
            ;;
    esac
done

L_ECLIPSE="eclipse$VERSION"
if [[ $VERSION == local ]] ; then
    . ~/scripts/envSimTG.sh
    L_ECLIPSE="eclipse"
fi

if [[ $CLEAN == 1 ]] ; then
    L_ECLIPSE="$L_ECLIPSE -clean"
fi

L_ECLIPSE="$L_ECLIPSE -w $WORKSPACE"
if [[ $VERSION == local ]] ; then
    L_ECLIPSE="$L_ECLIPSE &"
fi

# GTK fix for eclipse mars
export SWT_GTK3=0
export QT_GRAPHICSSYSTEM=native

# Theme
THEME_FILE=""
if [[ $THEME == "light" ]] ; then
    THEME_FILE=/home/comte/gtkrc-solarized-light
fi
if [[ $THEME == "dark" ]] ; then
    THEME_FILE=/home/comte/gtkrc-solarized-dark
fi
echo "Theme file : $THEME_FILE"

# Launch
echo
echo "### Launching with command \"$L_ECLIPSE\" ###"
GTK2_RC_FILES=$THEME_FILE $L_ECLIPSE #&>/tmp/eclipse.log &
#head /tmp/eclipse.log
