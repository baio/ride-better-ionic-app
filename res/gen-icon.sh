#!/bin/bash
# Generate PhoneGap icon and splash screens.
# Copyright 2013 Tom Vincent <http://tlvince.com/contact>

usage() { echo "usage: $0 icon colour [dest_dir]"; exit 1; }

[ "$1" ] && [ "$2" ] || usage
[ "$3" ] || set "$1" "$2" "."

devices=android,bada,bada-wac,blackberry,ios,webos,windows-phone
eval mkdir -p "$3/{icon,screen}"

# Show the user some progress by outputing all commands being run.
set -x

# Explicitly set background in case image is transparent (see: #3)
convert="convert -background none"
$convert "$1" -resize 29x29 "$3/icon/29.png"
$convert "$1" -resize 36x36 "$3/icon/36.png"
$convert "$1" -resize 40x40 "$3/icon/40.png"
$convert "$1" -resize 48x48 "$3/icon/48.png"
$convert "$1" -resize 50x50 "$3/icon/57.png"
$convert "$1" -resize 57x57 "$3/icon/57.png"
$convert "$1" -resize 58x58 "$3/icon/58.png"
$convert "$1" -resize 60x60 "$3/icon/60.png"
$convert "$1" -resize 62x62 "$3/icon/62.png"
$convert "$1" -resize 72x72 "$3/icon/72.png"
$convert "$1" -resize 76x76 "$3/icon/76.png"
$convert "$1" -resize 80x80 "$3/icon/80.png"
$convert "$1" -resize 96x96 "$3/icon/96.png"
$convert "$1" -resize 100x100 "$3/icon/100.png"
$convert "$1" -resize 114x114 "$3/icon/114.png"
$convert "$1" -resize 144x144 "$3/icon/144.png"
$convert "$1" -resize 120x120 "$3/icon/120.png"
$convert "$1" -resize 152x152 "$3/icon/152.png"
$convert "$1" -resize 173x173 "$3/icon/173.png"

