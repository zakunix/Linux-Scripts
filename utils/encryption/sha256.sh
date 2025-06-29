#!/bin/bash

# --- Help screen ---
case "$1" in
  -h|--help|/h|/help)
    echo
    echo "Generates SHA256 checksum for a given file."
    echo
    echo "USAGE:"
    echo "  $(basename "$0") file [variable]"
    echo
    echo "  variable  Optional shell variable name to store the checksum."
    echo
    exit 0
    ;;
esac

# --- Check file argument ---
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

# --- Check for sha256sum ---
if command -v sha256sum >/dev/null 2>&1; then
    sha256=$(sha256sum "$1" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    sha256=$(shasum -a 256 "$1" | awk '{print $1}')
else
    echo "No SHA256 checksum tool found (sha256sum or shasum required)."
    exit 4
fi

# --- Output or assign ---
if [[ -n "$2" ]]; then
    declare -g "$2=$sha256"
else
    echo "$sha256"
fi
