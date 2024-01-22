#!/bin/bash -e

CWD=$(realpath $(dirname $0))

mkdir -p "$CWD/${2:-"$1-autocutted"}"

echo "---------------------- cleaning audio"

#!/bin/bash

input_directory="./$1"

for video in "$input_directory"/*.MOV; do
  # Extract filename without extension
  filename=$(basename "$video" .MOV)
  
  # Check if the filename does not end with "_clean-audio"
  if [[ ! "$filename" =~ _clean-audio$ ]]; then
    clean_audio_video=$(realpath "$CWD/$(dirname "$video")/${filename}_clean-audio.MOV")
    # TODO: Add audio filter to normalize levels
    ffmpeg -y -i "$(realpath "$CWD/$video")" -af "afftdn=nr=10:nf=-30:tn=1" "$clean_audio_video"
  fi
done

echo "---------------------- cutting"

for video in "$input_directory"/*_clean-audio.MOV; do
  clean_audio_video=$( realpath "$video" )
  poetry -C "$CWD" run unsilence -y $clean_audio_video "$CWD/${2:-"$1-autocutted"}/$(basename $video)"
done
