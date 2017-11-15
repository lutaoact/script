#!/bin/bash -xv

# 当你使用未初始化的变量，则退出bash，也可以用set -u
set -o nounset

# 有任何命令的执行返回码非0，则退出bash，也可以用set -e
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
  _id: 'kirk_rs1_dev',
  members: [
    {_id: 0, host: '127.0.0.1:28001'},
    {_id: 1, host: '127.0.0.1:28002'},
    {_id: 2, host: '127.0.0.1:28003'},
  ],
};
rs.initiate(config);
EOF
