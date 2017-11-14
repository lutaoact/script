#!/bin/bash -xv

#当你使用未初始化的变量时，让bash自动退出
set -u

# 有任何一个语句返回非真的值，则退出bash，也可以用set -e
set -o errexit

function generate() {
    if [ -z "$1" ]; then
        exit 1
    fi
#    confPath=/tmp/replSet${1}.conf
    cat << EOF
storage:
  dbPath: /data/replSet/mongo${1}
  journal:
    enabled: true
  engine: wiredTiger

systemLog:
  destination: file
  path: /data/log/mongod${1}.log
  logAppend: true

net:
  port: 2800${1}
  bindIp: 127.0.0.1

processManagement:
  fork: true
  pidFilePath: /data/tmp/mongod${1}.pid

replication:
  replSetName: replSetTest
EOF
}
