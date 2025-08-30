num=$1
count=0
for (( i=1;i<=num;i++ )); do
	if [[ $(( num % i )) == 0 ]] ; then
		count=$(($count+1));
	fi
done
if [[ $count == 2 ]]; then
	echo "Yes"
else
	echo "No"
fi
