#!/bin/bash

function usage() {
    echo "Usage: $0 -i <album_art.jpg> -m <audio.mp3>"
    echo "  -i  JPEG image to embed"
    echo "  -m  MP3 file to embed image into"
    exit 1
}

function check_lame() {
    if ! command -v lame &>/dev/null; then
        echo "\"lame\" is not installed."

        read -rp "Do you want to install lame? [Y/N]: " ans
        case "$ans" in
            y|Y)
                if command -v apt &>/dev/null; then
                    sudo apt update && sudo apt install lame -y
                elif command -v dnf &>/dev/null; then
                    sudo dnf install lame -y
                elif command -v pacman &>/dev/null; then
                    sudo pacman -Sy lame
                else
                    echo "[x] Could not detect your package manager. Please install 'lame' manually."
                    exit 1
                fi
                ;;
            *)
                echo "[x] Cannot continue without \"lame\". Ending process..."
                exit 1
                ;;
        esac
    fi
}

while getopts ":i:m" opt; do
    case $opt in
        i) image="$OPTARG" ;;
        m) mp3="$OPTARG" ;;
        *) usage ;;
    esac
done

if [[ -z "$image" || -z "$mp3" ]]; then
    usage
fi

if [[ ! -f "$image" ]]; then
    echo "[e] Image file not found: $image"
    exit 1
fi

if [[ ! -f "$mp3" ]]; then
    echo "[e] MP3 file not found: $mp3"
    exit 1
fi

check_lame

echo "[i] Embedding '$image' into '$mp3'..."
lame --ti "$image" "$mp3"

if [[ $? -eq 0 ]]; then
    echo "[✓] Successfully embedded image."
else
    echo "[x] Failed to embed image."
fi
