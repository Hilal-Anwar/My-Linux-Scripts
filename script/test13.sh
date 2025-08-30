IFS=$\'\\n\'
old="delta"
new="gamma"
while read line; do
	if [[ $line =~ ^[0-9].* ]];then
		echo "$line" | sed "s/$old/$new/"
	else
		echo "$line"
	fi
done < input.txt
