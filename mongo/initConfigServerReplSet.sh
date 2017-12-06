#!/bin/bash -xv

# 当你使用未初始化的变量，则退出bash，也可以用set -u
set -o nounset

# 有任何命令的执行返回码非0，则退出bash，也可以用set -e
set -o errexit

mkdir -p /data/conf /data/tmp /data/log /data/configdb

. ./generateConfigServerReplSetConf.sh

for i in $(seq 1 3); do
    echo $i
    mkdir -p /data/configdb/mongo${i}
    confPath=/data/conf/mongodConfigServerReplSet${i}.conf
    generate $i > $confPath
    mongod --config $confPath
done

cat << EOF
mongo 127.0.0.1:29001
# 在mongo shell中，执行以下代码：
rs.initiate({
  _id: 'configServerReplSet',
  configsvr: true,
  members: [
    {_id: 0, host: '127.0.0.1:29001'},
    {_id: 1, host: '127.0.0.1:29002'},
    {_id: 2, host: '127.0.0.1:29003'},
  ],
});

# 启动mongos服务，mongos.conf在当前目录中
mongos --config mongos.conf
EOF
