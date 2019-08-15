#! /bin/bash
shopt -s extglob

filename=$(basename *.mp4)
if [[ ! -f $filename ]] ; then
    echo "No *.mp4 file => abort"
    exit 1
fi

file=${filename%.*}
if [[ ! -f "${file}.srt" ]] ; then
    echo "No subtitle => abort"
    exit 1
fi

echo "Creating ${file}.mkv..."
ffmpeg -i "${file}.mp4" -i "${file}.srt" -c:v copy -c:a copy -c:s srt "${file}.mkv"

echo "Deleting mp4 and srt..."
rm -v $(ls !(*.mkv))

echo "Done !"
