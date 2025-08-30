max=$1
min=$2
for i in $@
do 
	echo $i
	if [ "$i" -gt "$max" ]; then
	      max=$i
	fi
        if [ "$i" -lt "$min" ]; then
              min=$i
	fi	
done
echo "Maximum: $max | Minimum: $min"
