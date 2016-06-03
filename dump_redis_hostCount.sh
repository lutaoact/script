#!/bin/bash

if [ -z "$1" ]; then
  echo "date is required"
  exit 1
fi

date=$1

redis-cli -h mongo -n 1 --eval dump_redis_hostCount.lua , "$1" > /data/backup/dump_redis_hostCount_$1.txt
