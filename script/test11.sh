read -a number_arr
echo "${#number_arr[@]}"
s=0
for i in "${number_arr[@]}" ; do
	if [[ $((i % 2)) == 0 ]] ;then
		s=$((s+i))
	fi
done
echo $s
