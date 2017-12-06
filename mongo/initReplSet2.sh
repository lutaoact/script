#!/bin/bash -xv

# 当你使用未初始化的变量，则退出bash，也可以用set -u
set -o nounset

# 有任何命令的执行返回码非0，则退出bash，也可以用set -e
set -o errexit

mkdir -p /data/conf /data/tmp /data/log /data/replSet

. ./generateReplSetConf.sh

replSetName=kirk_rs2_dev

for i in $(seq 4 6); do
    echo $i
    mkdir -p /data/replSet/mongo${i}
    confPath=/data/conf/mongodReplSet${i}.conf
    generate $i $replSetName > $confPath
    mongod --config $confPath
done

cat << EOF
mongo 127.0.0.1:28004
# 在mongo shell中，执行以下代码：
rs.initiate({
  _id: '$replSetName',
  members: [
    {_id: 0, host: '127.0.0.1:28004'},
    {_id: 1, host: '127.0.0.1:28005'},
    {_id: 2, host: '127.0.0.1:28006'},
  ],
});

# 更新配置，在PRIMARY上执行
rs.reconfig({
  force: true,
  _id: '$replSetName',
  members: [
    {_id: 0, host: '127.0.0.1:28004'},
    {_id: 1, host: '127.0.0.1:28005'},
    {_id: 2, host: '127.0.0.1:28006'},
  ],
});
EOF
