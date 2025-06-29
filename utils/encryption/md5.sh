#!/bin/bash

# --- Help Menu ---
case "$1" in
  -h|--help|/h|/help)
    echo
    echo "Generates MD5 checksum for a given file."
    echo
    echo "USAGE:"
    echo "  $(basename "$0") file [variable]"
    echo
    echo "  variable  Optional: Shell variable name where the checksum will be stored."
    echo
    exit 0
    ;;
esac

# --- Validate Input ---
if [[ -z "$1" ]]; then
    echo "No file passed."
    echo "Pass -help to see the help message."
    exit 1
fi

if [[ ! -e "$1" ]]; then
    echo "File '$1' does not exist."
    exit 2
fi

if [[ -d "$1" ]]; then
    echo "'$1' is a directory."
    exit 3
fi

# --- Check if md5sum exists ---
if ! command -v md5sum >/dev/null 2>&1; then
    echo "'md5sum' is not installed or not in PATH."
    exit 4
fi

# --- Generate MD5 Checksum ---
md5=$(md5sum "$1" | awk '{print $1}')

# --- Output or store in variable ---
if [[ -n "$2" ]]; then
    declare -g "$2=$md5"
else
    echo "$md5"
fi
