#!/bin/bash
LINODE_HOST=45.79.74.193
LINODE_PORT=10026
function run() {
    while true
    do
        ssh -L *:10022:$LINODE_HOST:$LINODE_PORT -N proxy@$LINODE_HOST -p $LINODE_PORT
    done
}

run
# ssh -L *:[端口A]:[aws的ip]:[aws的ssh端口] -N [ssh账号]@[aws的ip] -p [aws的ssh端口]
