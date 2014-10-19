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
convert="convert $1 -background $2 -gravity center"

$convert -resize 192x320 "$3/screen/192x320.png"
$convert -resize 200x320 "$3/screen/200x320.png"
$convert -resize 225x225 "$3/screen/225x225.png"
$convert -resize 240x400 "$3/screen/240x400.png"
$convert -resize 288x480 "$3/screen/288x400.png"
$convert -resize 320x200 "$3/screen/320x200.png"
$convert -resize 320x480 "$3/screen/320x480.png"
$convert -resize 480x320 "$3/screen/480x320.png"
$convert -resize 480x800 "$3/screen/480x800.png"
$convert -resize 480x800 "$3/screen/480x800.jpg"
$convert -resize 640x1136 "$3/screen/640x1136.png"
$convert -resize 649x960 "$3/screen/649x960.png"
$convert -resize 720x1200 "$3/screen/720x1200.png"
$convert -resize 720x1280 "$3/screen/720x1280.png"
$convert -resize 768x1004 "$3/screen/768x1004.png"
$convert -resize 768x1024 "$3/screen/768x1024.png"
$convert -resize 800x480 "$3/screen/800x480.png"
$convert -resize 960x640 "$3/screen/960x640.png"
$convert -resize 1280x720 "$3/screen/1280x720.png"
$convert -resize 1024x768 "$3/screen/1024x768.png"
$convert -resize 1024x783 "$3/screen/1024x783.png"
$convert -resize 1536x2008 "$3/screen/1536x2008.png"
$convert -resize 2008x1536 "$3/screen/2008x1536.png"
$convert -resize 2048x1536 "$3/screen/2048x1536.png"
