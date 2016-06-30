#!/bin/bash -xv

#bash4.1 -xv xtrace和verbose 必须要写在一起，不能分开写成-x -v

#打开隧道
LOG_PATH=/data/log/bak.log
count=1
while [ $count -le 5 ]; do
  # 检查端口是否打开
  if nc -z 127.0.0.1 37017 &> /dev/null; then
    echo `date +'%F %T'` 'tunnel is ok' >> $LOG_PATH
    break
  else
    echo `date +'%F %T'` 'tunnel is not open' >> $LOG_PATH
  fi

  # 检查是否超过重试次数
  if [ $count -eq 5 ]; then
    echo `date +'%F %T'` 'tunnel can not open after 5 times retry' >> $LOG_PATH
    exit 1
  fi

  ssh -f -N -L37017:mongo:27017 dev
  sleep 5
  count=$[$count + 1]
done

cd /data/backup
dbname=gpws
suffix="$(date +'%Y%m%d%H')"
backup_path="$dbname_$suffix"

mongodump    --host=127.0.0.1 --port=37017 --db="$dbname" -o "$backup_path"
mongorestore --host=127.0.0.1 --port=27017 --db="$dbname" --drop \
             --numParallelCollections=4 --numInsertionWorkersPerCollection=4 \
             --batchSize=100 "$backup_path/$dbname/"
