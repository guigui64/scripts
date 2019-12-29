#! /bin/bash
if [ $# != 1 ] ; then echo "Usage: $0 <path_to_mkv>" ; exit 1 ; fi
file=$1
ffmpeg -i $file -map 0:v -c:v copy -map 0:a -c:a ac3 -b:a 640k -map 0:s -c:s copy out.mkv
rm $file
mv out.mkv $file

