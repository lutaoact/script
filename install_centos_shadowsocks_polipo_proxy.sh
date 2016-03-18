#!/bin/bash
# need root user to run this script

yum -y update
mkdir -p /data/tmp
chmod 777 /data/tmp

## 安装shadowsocks
yum -y install python-setuptools && easy_install pip
pip install shadowsocks

#写入shadowsocks的配置文件
cat << 'EOF' > /etc/shadowsocks.json
{
  "server":"52.69.198.217",
  "server_port":8388,
  "local_address": "127.0.0.1",
  "local_port":1080,
  "password":"sjtu1896",
  "timeout":600,
  "method":"aes-256-cfb"
}
EOF
sslocal -c /etc/shadowsocks.json -d start --pid-file /data/tmp/sslocal.pid --log-file /data/tmp/sslocal.log
echo "rum the following command to check log:"
echo "tail -f /data/tmp/sslocal.log"

## 安装polipo
yum -y install texinfo #安装make all所需要的依赖

cd ~
wget 'http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz'
tar xvfz polipo-1.1.1.tar.gz
cd polipo-1.1.1/
make all
make install

mkdir /etc/polipo
cat << EOF > /etc/polipo/config
socksProxyType = socks5
socksParentProxy = 127.0.0.1:1080
daemonise = true
pidFile = /data/tmp/polipo.pid
logFile = /data/tmp/polipo.log
EOF
polipo #启动 默认加载的配置文件为/etc/polipo/config
echo "rum the follow command to check log and running status:"
echo "tail -f /data/tmp/polipo.log"
echo "http_proxy=http://127.0.0.1:8123 curl google.com"
echo 'if you need the http_proxy env, run this command: export http_proxy=http://127.0.0.1:8123'

## 设置开机启动
cat << 'EOF' > /etc/init.d/proxyd
#!/bin/sh
###############
# SysV Init Information
# chkconfig: - 50 50
# description: proxyd is the proxy daemon.
# Author: Lu Tao
# Date: 2016-03-17
### BEGIN INIT INFO
# Provides: proxyd
# Required-Start: $network $local_fs $remote_fs
# Required-Stop: $network $local_fs $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Should-Start: $syslog $named
# Should-Stop: $syslog $named
# Short-Description: start sslocal and polipo
# Description: start sslocal and polipo when reboot
### END INIT INFO
/usr/bin/sslocal -c /etc/shadowsocks.json -d start --pid-file /data/tmp/sslocal.pid --log-file /data/tmp/sslocal.log
/usr/local/bin/polipo
EOF
chmod +x /etc/init.d/proxyd
chkconfig --add proxyd
