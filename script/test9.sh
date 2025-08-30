sum=0
while read line; do
	for word in $line; do
		if [[ $line != "" ]]; then
			((sum++))
		fi
	done
	shift
done < ../macmac.txt
echo $sum
