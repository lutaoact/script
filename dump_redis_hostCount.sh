#!/bin/bash

function export_one_day() {
  result=$(redis-cli -h mongo -n 1 --eval dump_redis_hostCount.lua , "$1")
  if [ -z "$result" ]; then
    echo "result for $1 is empty"
    exit 0
  fi

  echo "date: $1 => success"
  echo "$result" > /data/backup/dump_redis_hostCount_$1.txt
}

timestamp=$(date +'%s')
processing_timestamp=$[$timestamp - 86400 * 7]

while true
do
  dateStr=$(date -d @"$processing_timestamp" +'%Y%m%d')
  echo "date: $dateStr"

  export_one_day "dateStr"

  processing_timestamp=$[processing_timestamp - 86400]
done
