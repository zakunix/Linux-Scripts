#!/bin/bash

if [[ -z "$1" ]]; then
    read -rp "Enter the path to the video folder: " VIDEO_DIR
else
    VIDEO_DIR="$1"
fi

VIDEO_DIR="${VIDEO_DIR/#\~/$HOME}"
if [[ ! -d "$VIDEO_DIR" ]]; then
    echo "Directory \"$VIDEO_DIR\" does not exist."
    exit 1
fi

shopt -s nullglob nocaseglob
video_files=("$VIDEO_DIR"/*.{mp4,mkv,avi,webm,flv,mov})
shopt -u nullglob nocaseglob

if [[ ${#video_files[@]} -eq 0 ]]; then
    echo "No video files found in \"$VIDEO_DIR\"."
    exit 1
fi

random_video="${video_files[RANDOM % ${#video_files[@]}]}";
echo "Now playing: $random_video"

if command -v mpv &>/dev/null; then
    mpv "$random_video"
elif command -v vlc &>/dev/null; then
    vlc "$random_video"
else
    echo "No supported video player found (mpv or vlc)."
    exit 1
fi

