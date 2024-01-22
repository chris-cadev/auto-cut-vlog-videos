#!/bin/bash -e

CWD=$(realpath $(dirname $0))

mkdir -p "$CWD/${2:-"$1-autocutted"}"

echo "---------------------- cleaning audio"

for video in ./$1/*.MOV; do
  clean_audio_video=$( realpath "$CWD/$( dirname $video )/$( basename $video .MOV )_clean-audio.MOV" )
  # TODO: add audio filter to normalize levels
  ffmpeg -y -i $( realpath "$CWD/$video" ) -af "afftdn=nr=10:nf=-30:tn=1" $clean_audio_video
done

echo "---------------------- cutting"

for video in ./$1/*.MOV; do
  clean_audio_video=$( realpath "$CWD/$( dirname $video )/$( basename $video .MOV )_clean-audio.MOV" )
  poetry -C "$CWD" run unsilence -y $clean_audio_video "$CWD/${2:-"$1-autocutted"}/$(basename $video)"
done
