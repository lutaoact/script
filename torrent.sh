cd /tmp/testtorrent/download

torrent-create -a='udp://172.27.14.162:6881' ./out > out.torrent

# -addr 自己的可连接地址，上报给tracker服务器，供其他用户连接
# -seed 是否做种，如果为false，则只下载，不做种，如果为true，则应同时提供-addr参数，否则别的用户无从连接
torrent -addr=172.27.14.162:9991 -debug=true -seed=true out.torrent
torrent -addr=172.27.14.162:9992 -debug=true -seed=true out.torrent
torrent out.torrent

docker run -p 6880:6880 -p 6881:6881 -v /etc/chihaya.yaml:/etc/chihaya.yaml:ro quay.io/jzelinskie/chihaya-git:latest
