#!/bin/bash
#example for string entry : "Files /home/comte/workspace/obc/obc_oscar/test/obc_oscar/results/../scoc3/ref_32/testSPW10_dumpRxRxDesc.txt and /home/comte/workspace/obc/obc_oscar/test/obc_oscar/results/testSPW10_dumpRxRxDesc.txt differs at line 1"
if [[ -z $1 ]]
then
	echo "Need an argument"
else

	string="$1"
	
	name1=$(echo $string | awk '{print $2}')
	name2=$(echo $string | awk '{print $4}')

	file1=/tmp/file1-$(basename $name1)
	file2=/tmp/file2-$(basename $name2)
	cp $name1 $file1
	cp $name2 $file2

	# remove beginning and end
	sed -i "s/^.*://g" $file1
	sed -i "s/^.*://g" $file2
	sed -i "s/ \{5\}.*$//g" $file1
	sed -i "s/ \{5\}.*$//g" $file2

	# remove all spaces and join lines
	cat $file1 | tr -d ' ' | tr -d '\n' > $file1.end
	cat $file2 | tr -d ' ' | tr -d '\n' > $file2.end

	mv $file1.end $file1
	mv $file2.end $file2

	res=$(diff -s $file1 $file2)
	echo $res
	
	if [[ $res == *"identical"* ]]
	then
		cp -v $name2 $name1
	fi
fi
