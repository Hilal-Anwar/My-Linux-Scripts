while read line; do
	echo ${line%%:*}
done </../etc/passwd


