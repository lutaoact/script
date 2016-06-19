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

# 如果提供了日期，就从提供的日期开始，向前处理
# 如果没有提供日期，则向前推7天开始处理
if [ -n "$1" ]; then
  processing_timestamp=$(date -d "$1" +'%s')
else
  processing_timestamp=$[$(date +'%s') - 86400 * 3]
fi

while true
do
  dateStr=$(date -d @"$processing_timestamp" +'%Y%m%d')
  echo "date: $dateStr"

  export_one_day "$dateStr"

  processing_timestamp=$[processing_timestamp - 86400] #推到前一天
done
