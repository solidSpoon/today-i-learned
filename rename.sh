#!/bin/bash

# Function to replace spaces with underscores in file/directory names
function replace_spaces {
  for old in "$1"/*; do
    new=$(echo "$old" | tr ' ' '_')
    if [ "$old" != "$new" ]; then
      mv "$old" "$new"
    fi
    if [ -d "$new" ]; then
      replace_spaces "$new"
    fi
  done
}

# Start the replacement from the current directory
replace_spaces .