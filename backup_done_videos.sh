#!/bin/bash -xv

trap 'exit 1' 1 2 3 9 15

set -e

remotePath="/data/videos/output"
localPath="/data/backup/done"

for i in $(cat done.list); do
  scp s:"$remotePath/$i" "$localPath/$i"
  mv "$localPath/$i" "$localPath/${i/.done/}"
  ssh s rm "$remotePath/$i"
done
