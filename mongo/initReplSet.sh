#!/bin/bash -xv

#当你使用未初始化的变量时，让bash自动退出
set -u

# 有任何一个语句返回非真的值，则退出bash，也可以用set -e
set -o errexit

mkdir -p /data/tmp /data/log /data/replSet

. ./generateReplSetConf.sh

for i in $(seq 1 3); do
    echo $i
    mkdir -p /data/replSet/mongo${i}
    confPath=/tmp/replSet${i}.conf
    generate $i > $confPath
    mongod --config $confPath
done

cat << EOF
mongo 127.0.0.1:28001
# 在mongo shell中，执行以下代码：
var config = {
  _id: 'replSetTest',
  members: [
    {_id: 0, host: '127.0.0.1:28001'},
    {_id: 1, host: '127.0.0.1:28002'},
    {_id: 2, host: '127.0.0.1:28003'},
  ],
};
rs.initiate(config);
EOF
