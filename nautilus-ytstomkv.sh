#! /bin/bash
shopt -s extglob

filename=$(basename *.mp4)
if [[ ! -f $filename ]] ; then
    zenity --error --text="No *.mp4 file => abort"
    exit 1
fi

file=${filename%.*}
if [[ ! -f "${file}.srt" ]] ; then
    zenity --error --text="No subtitle => abort"
    exit 1
fi

(
echo "# Creating ${file}.mkv..."
echo "10"
ffmpeg -i "${file}.mp4" -i "${file}.srt" -c:v copy -c:a copy -c:s srt -metadata:s:s:0 language=eng "${file}.mkv"

echo "# Deleting mp4 and srt..."
echo "90"
sleep 1
rm -v $(ls !(*.mkv))

echo "# Done !"
echo "100"
) | zenity --progress --auto-close --title="YTS to MKV"
