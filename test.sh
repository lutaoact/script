#!/bin/bash

tables=(analyst code_info customize_alarm effect_topic favor_stock_alarm \
    hot_stock invitation new_stock push_token recharge redeem_code stock \
    theme theme_stock top_info user user_action)

for i in "${tables[@]}"; do
  echo $i
done

cd ~/node-server
pm2 start app.js
pm2 start netServer.js

cd ~/node-recharge
export NODE_ENV=recharge-dev
pm2 start app.js --name recharge

echo 'ddxd2015' | sudo -S service stop redis
mv /data/redis/dump.rdb /data/redis/dump.bak.rdb
scp mongo:/data/redis/dump.rdb /data/redis
echo 'ddxd2015' | sudo -S service start redis


#if [ -n "$1" ]; then
#  processing_timestamp=$(date -d "$1" +'%s')
#else
#  processing_timestamp=$[$(date +'%s') - 86400 * 7]
#fi
#
#echo $processing_timestamp

#echo "!hhh";
#
#if [ "$1" = 'all' ]; then
#  echo 'all here'
#else
#  echo 'not all here'
#fi
#

#ts=$(date +'%s')
#
#while true
#do
#  echo $ts
#  dateStr=$(date -d @"$ts" +'%Y%m%d')
#  echo $dateStr
#
#  ts=$[ts - 86400]
#  if [ $dateStr -eq '20160321' ]; then
#    exit 0
#  fi
#done
#
