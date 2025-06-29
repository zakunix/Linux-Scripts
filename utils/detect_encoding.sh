#!/bin/bash

print_help() {
    echo
    echo "$(basename "$0") file - Detects encoding of a text file."
    echo
    echo "Returns text + exit code:"
    echo "  1 - UTF-8"
    echo "  2 - UTF-16 BE"
    echo "  3 - UTF-16 LE"
    echo "  4 - UTF-32 BE"
    echo "  5 - UTF-32 LE"
    echo "  6 - ASCII (no BOM)"
    echo
    echo " 52 - Empty file"
    echo " 53 - File is a directory"
    echo " 54 - File does not exist"
    exit 0
}

case "$1" in
    -h|--help|"-?")
        print_help
        ;;
    "")
        print_help
        ;;
esac

file="$1"

if [[ ! -e "$file" ]]; then
    echo "File does not exist."
    exit 54
fi

if [[ -d "$file" ]]; then
    echo "This cannot be used against directories."
    exit 53
fi

if [[ ! -s "$file" ]]; then
    echo "Empty files are not accepted."
    exit 52
fi

bom=$(head -c 4 "$file" | od -An -tx1 | head -n1 | xargs)

case "$bom" in
    "ef bb bf"*)
        echo "utf-8"
        exit 1
        ;;
    "fe ff 00"*)
        echo "utf-16 BE"
        exit 2
        ;;
    "ff fe"*)
        if [[ "$bom" == "ff fe 00 00"* ]]; then
            echo "utf-32 LE"
            exit 5
        else
            echo "utf-16 LE"
            exit 3
        fi
        ;;
    "00 00 fe ff"*)
        echo "utf-32 BE"
        exit 4
        ;;
esac

echo "ASCII"
exit 6
