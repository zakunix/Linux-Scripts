#!/bin/bash

case "$1" in
    -h|--help)
        echo
        echo "$(basename "$0") <file> - Displays LastModified, LastAccessed, and DateCreated times"
        echo "                         in format YYYYMMDDhhmmss"
        echo
        echo "Example:"
        echo "  ./$(basename "$0") /path/to/file.txt"
        exit 0
        ;;
esac

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

file=$(realpath "$1")
echo "File timestamps for \"$file\":"
echo

format_time() {
    date -d @"$1" +"%d-%m-%Y_%H:%M:%S"
}

read atime mtime ctime <<< $(stat -c "%X %Y %Z" "$file")

echo "Last accessed: $(format_time "$atime")"
echo "Last modified: $(format_time "$mtime")"
echo "Date created : $(format_time "$ctime")"
