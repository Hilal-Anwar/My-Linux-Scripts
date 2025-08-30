for i in {1..500}; do
	for j in  $(seq 1 $i); do
		echo -n "$j "
	done
	echo ""
done

