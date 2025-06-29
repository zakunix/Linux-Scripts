#!/bin/bash

# --- Help Screen ---
case "$1" in
  -h|--help|/h|/help)
    echo
    echo "Generates SHA384 checksum for a given file."
    echo
    echo "USAGE:"
    echo "  $(basename "$0") file [variable]"
    echo
    echo "  variable  Optional shell variable name to store the checksum."
    echo
    exit 0
    ;;
esac

# --- Argument validation ---
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

# --- Tool check & compute SHA384 ---
if command -v sha384sum >/dev/null 2>&1; then
    sha384=$(sha384sum "$1" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    sha384=$(shasum -a 384 "$1" | awk '{print $1}')
else
    echo "No SHA384 checksum tool found (need sha384sum or shasum)."
    exit 4
fi

# --- Output or assign to shell variable ---
if [[ -n "$2" ]]; then
    declare -g "$2=$sha384"
else
    echo "$sha384"
fi
