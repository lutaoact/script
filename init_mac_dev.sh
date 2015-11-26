redis-server ~/some_config/redis.conf
#mongod --logappend --logpath /data/log/mongod.log --fork
rm -rf /data/pid/polipo.pid && polipo -c ~/some_config/polipo.conf
