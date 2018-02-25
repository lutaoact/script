## 通过源代码安装redis
apt install -y tcl #安装tcl依赖

wget http://download.redis.io/releases/redis-4.0.8.tar.gz
tar xzf redis-4.0.8.tar.gz
cd redis-4.0.8
make && make test && make install

cd utils
./install_server.sh

# redis的相关配置
#Port           : 6379
#Config file    : /etc/redis/6379.conf
#Log file       : /var/log/redis_6379.log
#Data dir       : /var/lib/redis
#Executable     : /usr/local/bin/redis-server
#Cli Executable : /usr/local/bin/redis-cli

cat <<HERE > /etc/systemd/system/redis.service
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/6379.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always
Type=forking

[Install]
WantedBy=multi-user.target
HERE

# 设置 redis 用户和组信息
adduser --system --group --no-create-home redis
chown redis:redis /var/lib/redis
chmod 770 /var/lib/redis
chown redis:redis /var/log/redis_6379.log

# 启动
systemctl enable redis
systemctl start redis
systemctl status redis

# 如果有报错，就执行 journalctl -f 查看启动日志
# 也可以看 tail -f /var/log/redis_6379.log
# 一般都是各种权限问题
