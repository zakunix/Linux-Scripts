#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Parameter not specified."
    exit 1
fi

base="$1"
ext="${base##*.}"
prefix="$base.part"

mapfile -t parts < <(ls "$prefix".* 2>/dev/null | sort -t. -k3 -n)

if [[ ${#parts[@]} -eq 0 ]]; then
    echo "No parts found for '$base'"
    exit 2
fi

# Build final filename (with extension if it was given)
output="$base"
if [[ "$output" != *.* ]]; then
    output="${base}.${ext}"
fi

# Join all parts into the output file
cat "${parts[@]}" > "$output"

echo "✅ File reassembled as: $output"
