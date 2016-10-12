#!/bin/bash -xv

ENV=$1

## redis部分
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

## mongo部分
# mongodump的-o选项指定的目录如果不存在会自动新建，导出数据时，会另外新建以database命名的目录来实际存储数据
ssh $host "cd /tmp && mongodump -d guwan -o ./ && tar cvfz - guwan" \
      | tar xvfz - -C /tmp && mongorestore -d guwan --drop --dir=/tmp/guwan
