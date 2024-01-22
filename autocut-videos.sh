#!/bin/bash -e

CWD=$(realpath $(dirname $0))

mkdir -p "$CWD/${2:-"$1-autocutted"}"

echo "---------------------- converting to mp4"

for video in ./$1/*.MOV; do
  mp4_video=$( realpath "$CWD/$( dirname $video )/$( basename $video .MOV ).mp4" )
  ffmpeg -y -i $( realpath "$CWD/$video" ) $mp4_video
done

echo "---------------------- cutting"

for video in ./$1/*.MOV; do
  mp4_video=$( realpath "$CWD/$( dirname $video )/$( basename $video .MOV ).mp4" )
  poetry -C "$CWD" run unsilence -y $mp4_video "$CWD/${2:-"$1-autocutted"}/$(basename $video)"
done
