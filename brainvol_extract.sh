#!/bin/bash
#
# brainvol_extract.sh input_file output_file

input_file=$1
output_file=$2

# Remove existing output file if it exists
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

# Write the CSV header
echo "Measure_ID, Measure Value" >> "$output_file"

# Read each line in the input file and convert it to CSV format
while IFS= read -r line; do
    # Extract the values from the line
    measure_name=$(echo "$line" | cut -d',' -f1)
    measure_id=$(echo "$line" | cut -d',' -f2)
    measure_description=$(echo "$line" | cut -d',' -f3)
    measure_value=$(echo "$line" | cut -d',' -f4)
    unit=$(echo "$line" | cut -d',' -f5)

    # Write the values to the output file in CSV format
    echo "$measure_id, $measure_value" >> "$output_file"
done < "$input_file"

# transpose the output_file csv
awk -F, '
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str","a[i,j];
        }
	print str
    }
}' "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"

# remove the first space in the 2nd row
sed -i 's/ //2' "$output_file"

# remove the first column
cut -d, -f2- "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"

# remove all the spaces
sed -i 's/ //g' "$output_file"

echo "Conversion completed. Output file: $output_file"

