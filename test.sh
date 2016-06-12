#!/bin/bash

if [ -n "$1" ]; then
  processing_timestamp=$(date -d "$1" +'%s')
else
  processing_timestamp=$[$(date +'%s') - 86400 * 7]
fi

echo $processing_timestamp

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
