#!/bin/bash

print_help() {
    echo "Generates SHA512 checksum for specified file."
    echo
    echo "USAGE:"
    echo
    echo "$(basename "$0") <file> [variable]"
    echo
    echo "If [variable] is provided, the checksum will be assigned to that shell variable."
}

if [[ -z "$1" ]]; then
    echo "No file specified."
    echo "Pass -help to see help message."
    exit 1
fi

case "$1" in
    -h|-help)
        print_help
        exit 0
        ;;
esac

if [[ ! -e "$1" ]]; then
    echo "File \"$1\" does not exist."
    exit 2
fi

if [[ -d "$1" ]]; then
    echo "\"$1\" is a directory."
    exit 3
fi

if ! command -v sha512sum &>/dev/null; then
    echo "\"sha512sum\" not found. Please install the necessary library."
    exit 4
fi

sha512=$(sha512sum "$1" | awk '{print $1}')

if [[ -n "$2" ]]; then
    declare -g "$2=$sha512"
else
    echo "$sha512"
fi
