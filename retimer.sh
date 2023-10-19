#!/bin/sh

# Output file
OUTPUT_FILE="file_info.txt"

# Function to calculate BLAKE3 hash
calculate_blake3() {
  b3sum "$1" | awk '{print $1}'
}

# Function to get mtime, BLAKE3 hash, and filename
get_file_info() {
  local file="$1"
  local mtime=$(stat -c "%Y" "$file")
  local blake3=$(calculate_blake3 "$file")
  echo "$mtime $blake3 $file"
}

# Iterate through files and write their info to the output file
rm -f file_info.txt
find src -type f | while read -r file; do
  get_file_info "$file" >> "$OUTPUT_FILE"
done
