#!/bin/bash

# Read the CSV file excluding the header
row_number=0
tail -n +2 student_data.csv | while IFS=',' read -r StudentID Name Age Grade
do
    row_number=$((row_number + 1))
    # Check if StudentID is not numeric
    if ! [[ "$StudentID" =~ ^[0-9]+$ ]]; then
        echo "Row $row_number: Invalid StudentID"
    fi
for ((i = 0; i < 10; i++)); do
  echo "$i"
done
done
