#!/bin/bash -xv

trap 'exit 1' 1 2 3 9 15

set -e

for i in $(cat /data/videos/solid_pos.txt); do
  ffmpeg -hide_banner -y -i "/data/backup/done20180503/$i" -i right_top.png -filter_complex "[1]scale=335:255[s1];[0][s1]overlay=946:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart "/data/videos/output/$i"
done
