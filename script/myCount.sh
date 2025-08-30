
FILE="${@: -1}"
while getopts ":lwns:" opt; do
	case $opt in
		l) awk "END { print NR }" $FILE  ;;
		w) awk "BEGIN { WORD=0 } { WORD+=NF } END { print WORD}" $FILE ;;
		n) awk "BEGIN { COUNT =0 } /^[[:digit:]]+/ { COUNT+=1 } END {print COUNT}" $FILE ;;
		s) awk "BEGIN { COUNT =0 } /$OPTARG/ { COUNT+=1 } END {print COUNT}" $FILE ;;
	esac
done
