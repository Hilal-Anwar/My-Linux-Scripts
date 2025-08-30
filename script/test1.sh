echo "Enter a:"
read a
echo "Enter b:"
read b
x=$(echo "$a / $b" | bc -l)
echo "$x"
base=2
exponent=8
result=$(echo "$base^$exponent" | bc)
echo "The result is: $result"
