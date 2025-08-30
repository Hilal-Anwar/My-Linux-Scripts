#!/bin/bash

# Input files
shopfile="ocr_shopname.txt"
namefile="ocr_names.txt"
seqfile="ocr_seqno.txt"
itemrecord="ocr_item_record.txt"
# Get total number of cards
total_cards=$(grep -v "^\[File:.*" "$shopfile" | wc -l)
for (( i=1;i<=$total_cards;i++));do
	shopname=$( awk -v n=$i 'BEGIN{ FS=" " } $0 !~ /\[File:.*/ && int(NR/3)==n{
	print $0 
	}' "$shopfile" )
	customer=$( awk -v n=$i 'BEGIN{ FS=" " } $0 !~ /\[File:.*/ && int(NR/3)==n{
	if (n==10) { print "Rajesh" }
	else if (n==23){ print "Julia" }
	else if (length($1)>2){ print $1 }
	else{
	 print $2
	}
	}' "$namefile" )
	record=$( awk -v n=$i '/:.*/{
	NUM=int(substr($3,6,2));
	}
	$0 !~ /\[File:.*/{
	  if (n==NUM)
	  {
	    if (NF==5 && ($5+0) == $5)
		{
		      sub(/=/,"",$2)
			  if(n==26)
			  {
				  if($1=="Curd"){
				  printf "%s:%s:%s:%s:%s\n",$1,$2,$3,$5/$3,$5
				  }
				  else if($1=="Milk")
				  {
				  printf "%s:%s:%s:%s:%s\n",$1,$2,$5/$4,$4,$5
				  }
                  else
			     {
                  printf "%s:%s:%s:%s:%s\n",$1,$2,$3,$4,$5
			     }
			  }
			   else
			     {
                  printf "%s:%s:%s:%s:%s\n",$1,$2,$3,$4,$5
			     }
		 }
	    else if(NF==6 && ($6+0) == $6){
		        sub(/=/,"",$3)
                printf "%s %s:%s:%s:%s:%s\n",$1,$2,$3,$4,$5,$6
		}
	  }
	}' "$itemrecord" )
    echo -e "$shopname:$customer:$i\nItem:Category:Qty:Price:Cost\n$record\n" >> "shopping_bill_$i.txt"
done
