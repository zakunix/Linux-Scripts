#!/bin/bash

# Usage: ./stringToHex.sh <source_file> <destination_file>

if [[ -z "$2" ]]; then
    echo "Destination not given."
    exit 10
fi

src_file=$(realpath "$1")
dest_file=$(realpath "$2")

if [[ ! -f "$src_file" ]]; then
    echo "Source file \"$src_file\" does not exist."
    exit 11
fi

rm -f "$dest_file"

xxd -p -c 24 "$src_file" | tr "a-f" "A-F" > "$dest_file"
