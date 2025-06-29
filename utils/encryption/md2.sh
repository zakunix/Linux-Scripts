#!/bin/bash

case "$1" in
    -h|--help)
        echo
        echo "Generates MD2 checksum for a given file"
        echo
        echo "USAGE:"
        echo "  $(basename "$0") file [variable]"
        echo
        echo "  variable  Optional: Shell variable name where the checksum will be stored"
        echo
        exit 0
        ;;
esac

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

# --- Check if openssl is available ---
if ! command -v openssl >/dev/null 2>&1; then
    echo "OpenSSL is not installed or not in PATH."
    exit 4
fi

md2=$(openssl dgst -md2 "$1" 2>/dev/null | awk '{print $2}')

if [[ -z "$md2" ]]; then
    echo "Failed to generate MD2 checksum. Your OpenSSL may not support it."
    exit 5
fi

if [[ -n "$2" ]]; then
    declare -g "$2=$md2"
else
    echo "$md2"
fi
