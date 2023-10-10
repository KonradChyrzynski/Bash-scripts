#!/bin/bash

if [ $# -lt 3 ]; then
  echo "Usage: $0 <directory_path> <pattern_to_replace> <case_option>"
  exit 1
fi

directory_path="$1"
pattern_to_replace="$2"
case_option="$3"

# Convert the pattern to lower and upper case for case-insensitive search
pattern_lowercase=$(echo "$pattern_to_replace" | tr '[:upper:]' '[:lower:]')
pattern_uppercase=$(echo "$pattern_to_replace" | tr '[:lower:]' '[:upper:]')

# Find all files and directories in the specified directory
find "$directory_path" -depth | while IFS= read -r entry; do
  # Check if the entry is a file or a directory
  if [ -f "$entry" ]; then
    # Replace pattern with the specified case in filenames
    new_name=$(echo "$entry" | sed "s/$pattern_to_replace/$case_option/gI")
    if [ "$entry" != "$new_name" ]; then
      mv "$entry" "$new_name"
      echo "Renamed file: $entry -> $new_name"
    fi
  elif [ -d "$entry" ]; then
    # Replace pattern with the specified case in directory names
    new_name=$(echo "$entry" | sed "s/$pattern_to_replace/$case_option/gI")
    if [ "$entry" != "$new_name" ]; then
      mv "$entry" "$new_name"
      echo "Renamed directory: $entry -> $new_name"
    fi
  fi
done

echo "Pattern replacement and renaming completed."
