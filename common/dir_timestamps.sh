#!/bin/bash

print_help() {
    echo
    echo "$(basename "$0") - Displays LastModified, LastAccessed, and DateCreated times of a given directory"
    echo "                   in format YYYYMMDDhhmmss"
    echo
    echo "Example:"
    echo "  ./$(basename "$0") \"/path/to/directory\""
    echo
}

case "$1" in
    -h|--help)
        print_help
        exit 0
        ;;
esac

if [[ -z "$1" ]]; then
    echo "No directory passed."
    exit 1
fi

if [[ ! -e "$1" ]]; then
    echo "Directory \"$1\" does not exist."
    exit 2
fi

if [[ ! -d "$1" ]]; then
    echo "\"$1\" is a file but not a directory."
    exit 3
fi

dir=$(realpath "$1")

echo
echo "Directory timestamps for: $dir"
echo

stat_output=$(stat --format="%X %Y %Z" "$dir" 2>/dev/null)

if [[ $? -ne 0 ]]; then
    echo "Error: Unable to read directory timestamps."
    exit 4
fi

read atime mtime ctime <<< "$stat_output"

format_time() {
    date -d @"$1" +"%Y/%m/%d-%H:%M:%S"
}

echo "Last Accessed : $(format_time "$atime")"
echo "Last Modified : $(format_time "$mtime")"
echo "Date Created  : $(format_time "$ctime")"
