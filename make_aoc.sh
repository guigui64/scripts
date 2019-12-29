filename=$1
newfile=${filename%.*}.py

if [ -f $newfile ]; then
    echo "File $newfile already exists"
else
    echo "f = open(\"$1\", \"r\")

for line in f.readlines():" > $newfile
fi
