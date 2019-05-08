#!/bin/bash

mysql_port=$(docker inspect mysql3306 | jq -r '.[0].NetworkSettings.Ports["3306/tcp"][0].HostPort')
redis_port=$(docker inspect redis6379 | jq -r '.[0].NetworkSettings.Ports["6379/tcp"][0].HostPort')

gsed -i '/^Host me$/{N;N;N;N;s/[[:digit:]]\+$/'"$mysql_port"'/;}' ~/.ssh/config
gsed -i '/^Host me2$/{N;N;N;N;s/[[:digit:]]\+$/'"$redis_port"'/;}' ~/.ssh/config

tmux kill-session

# 新建 session，并会默认新建一个 window
tmux new-session -d -s my_session

# 所以我们新建 window 的时候，编号从 1 开始，0 号是默认的
# -n 表示 window 的名称
# -t 表示 target，指定 session 的 window
tmux new-window -t my_session:1 -n me
tmux new-window -t my_session:2 -n me2

# 想指定 target 发送需要执行的命令，注意最后的 ENTER 不能少
tmux send-keys -t my_session:me.0 'autoconnect me' ENTER
tmux send-keys -t my_session:me2.0 'autoconnect me2' ENTER
