#! /usr/bin/env bash

wd=$1
FILES=$(git status -s $wd | rg "^.M" | awk '{print $2}')
for file in $FILES; do
    clear;
    BASE=$(basename -- $file)
    EXT=${BASE##*.}
    DO_DIFF="yes"
    if [[ $EXT == "smf" ]] ; then
        read -p "Output diff of file $file ? [Y/n]" -n 1 -e;
        if [[ $REPLY == "n" ]] ; then
            DO_DIFF="no";
        fi
    fi
    if [[ $DO_DIFF == "yes" ]] ; then
        git diff $file;
    fi
#    select COMMAND in "Checkout" "Add" "Do nothing" ; do
#        case $COMMAND in
#            "Checkout") git checkout $file; break;;
#            "Add")      git add $file;      break;;
#            *)                              break;;
#        esac
#    done
    echo $file
    echo "[Cc]:     Checkout file"
    echo "[Aa]:     Add file"
    echo "[Enter]:  Do nothing"
    read -n 1 -e;
    case $REPLY in
        [Cc])  git checkout $file;;
        [Aa])  git add $file;;
    esac
done

clear;

git status -s;
