#!/bin/bash

# 切换到root用户执行
su

# 压缩包放在这个目录
cd /data/backup

tar xvfz zabbix-2.4.8.tar.gz
cd zabbix-2.4.8
./configure --prefix=/usr/local/zabbix_agent --enable-agent
make &&  make install

#zebbix agent service secript
cp /data/backup/zabbix-2.4.8/misc/init.d/tru64/zabbix_agentd /etc/init.d/
chmod +x /etc/init.d/zabbix_agentd
sed -i -e "s#DAEMON.*zabbix_agentd#DAEMON\=/usr/local/zabbix_agent/sbin/zabbix_agentd#g" \
       -e "s#PIDFILE.*pid#PIDFILE\=/usr/local/zabbix_agent/logs/zabbix_agentd.pid#g" \
/etc/init.d/zabbix_agentd

#zabbix agent config
sed -i -e "s/Server\=127.0.0.1/Server\=10.252.95.29/g" \
       -e "s/ServerActive\=127.0.0.1/ServerActive\=10.252.95.29/g" \
       -e "s#tmp/zabbix_agentd.log#usr/local/zabbix_agent/logs/zabbix_agentd.log#g" \
       -e "s#.*PidFile=/tmp/zabbix_agentd.pid#PidFile=/usr/local/zabbix_agent/logs/zabbix_agentd.pid#g" \
       /usr/local/zabbix_agent/etc/zabbix_agentd.conf

# add user
useradd -s /sbin/nologin zabbix

#zabbix agent log
mkdir -p /usr/local/zabbix_agent/logs
chown -R zabbix:zabbix /usr/local/zabbix_agent/logs
service zabbix_agentd start

tail -f /usr/local/zabbix_agent/logs/zabbix_agentd.log
