#! /bin/bash

echo -e "\n### Subtitles ###"
for folder in * ; do
    echo -e "\n### Folder $folder"
    cd "$folder"
    
    filename=$(basename *.mp4)
    if [[ ! -f $filename ]] ; then
        echo "No *.mp4 file => abort"
        cd ..
        continue
    fi
    
    file=${filename%.*}
    if [[ ! -f "${file}.srt" ]] ; then
        OpenSubtitlesDownload.py --cli $filename
    fi
    
    cd ..
done

echo -e "\n### Merge mp4+srt to mkv ###"
sleep 1
for folder in * ; do
    echo -e "\n### Folder $folder"
    cd "$folder"
    
    ytstomkv.sh
    
    cd ..
done

echo -e "\n### Reload minidlna DB (password required) ###"
sudo service minidlna stop
sudo minidlnad -R
sudo service minidlna start
