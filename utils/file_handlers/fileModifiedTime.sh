#!/bin/bash

if [[ "$1" =~ ^(-h|--help)$ ]]; then
    echo
    echo "$(basename "$0") <file> [rtnVar] - Gets last modified time of a file in YYYY/MM/DD HH:MM:SS format"
    echo
    echo "  rtnVar - Optional: Shell variable name to store the result"
    echo
    echo "Example:"
    echo "  ./$(basename "$0") /path/to/file.txt lastModified"
    echo
    exit 0
fi

if [[ -z "$1" ]]; then
    echo "No file passed."
    exit 1
fi

if [[ ! -e "$1" ]]; then
    echo "File \"$1\" does not exist."
    exit 2
fi

if [[ -d "$1" ]]; then
    echo "\"$1\" is a directory, not a file."
    exit 3
fi

# Get file modified time
mod_time=$(stat -c "%y" "$1" 2>/dev/null | awk '{print $1 " " $2}' | cut -c1-19 | sed 's/-/\//g')

echo "Last modified date of \"$1\":"
echo "$mod_time"

if [[ -n "$2" ]]; then
    declare -g "$2=$mod_time"
fi
