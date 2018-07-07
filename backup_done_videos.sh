#!/bin/bash -xv

trap 'exit 1' 1 2 3 9 15

set -e

remotePath="/data/videos/uploaded"
localPath="/data/backup/done$(date +%Y%m%d)"

# 如果目录不存在就新建一个，按照日期建目录，不要在一个目录中存放过多的文件
mkdir -p "$localPath"

for i in $(cat done.list); do
  scp s:"$remotePath/$i" "$localPath/$i"
  ssh s rm "$remotePath/$i"
done
