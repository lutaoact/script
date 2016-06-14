#!/bin/bash -xv

result=$(redis-cli -h mongo -n 1 --eval clear_noMoreUpdateCount.lua)
if [ -z "$result" ]; then
  echo "result is empty"
  exit 0
fi

echo "$result" > /data/backup/clear_noMoreUpdateCount.txt
