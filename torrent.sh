cd /tmp/testtorrent/download

torrent-create -a='udp://172.27.14.162:6881' ./out > out.torrent
torrent -addr=172.27.14.162:9991 -debug=true -seed=true out.torrent
