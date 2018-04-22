#!/bin/bash -xv

# 当你使用未初始化的变量，则退出bash，也可以用set -u
set -o nounset

# 有任何命令的执行返回码非0，则退出bash，也可以用set -e
set -o errexit

cd /data/conf

# 启动两个不同的复制集，各3台服务器
for i in $(seq 1 6); do (mongod --config mongodReplSet${i}.conf &); done

# 启动configdb复制集
for i in $(seq 1 3); do (mongod --config mongodConfigServerReplSet${i}.conf &); done

# 启动mongos
mongos --config mongos.conf

# 打出mongos的一些命令
cat << EOF
mongo 127.0.0.1:30001/admin
# 在mongo shell中，执行以下代码：
sh.addShard("kirk_rs1_dev/127.0.0.1:28001,127.0.0.1:28002,127.0.0.1:28003")
sh.addShard("kirk_rs2_dev/127.0.0.1:28004,127.0.0.1:28005,127.0.0.1:28006")

sh.enableSharding( "hms" )


use hms;
// shard key必须要有索引
db.testColl.createIndex({_id: 1})
sh.shardCollection( "hms.testColl", { "_id" : 1 } )

db.testColl.createIndex({name: 1})
sh.shardCollection( "hms.testColl", { "name" : 1 } )

db.adminCommand( { moveChunk : "hms.testColl",
                   find : {name : "Kristina"},
                   to : "kirk_rs2_dev" } )
EOF
