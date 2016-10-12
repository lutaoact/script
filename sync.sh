#!/bin/bash -xv

ENV=$1

redis-cli -p 8888 shutdown

if [ x"$1" == x"dev" ]; then
  host=dev
  from_path=/data/redis/dump8888.rdb
elif [ x"$1" == x"pdt" ]; then
  host=gw
  from_path=/var/lib/redis/8888/dump.rdb
else
  echo 'Usage: ./sync.sh [dev/pdt]'
  exit 1
fi

to_path=/data/redis/dump8888.rdb

scp $host:"$from_path" "$to_path" && redis-server ~/guwan/conf/8888.conf
