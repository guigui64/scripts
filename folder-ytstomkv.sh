#! /bin/bash

for folder in * ; do
    echo -e "\n\n### DOING $folder"
    cd "$folder"
    ytstomkv.sh
    cd ..
done

