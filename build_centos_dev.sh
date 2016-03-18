#!/bin/bash

## 一些必须要装的软件
yum -y update
yum -y install tmux

yum -y install krb5-devel #安装`mongoose`报错，`gssapi.h：No such file or directory`

#修改vi指向vim
mv /usr/bin/vi /usr/bin/vi_bak
ln -s /usr/bin/vim /usr/bin/vi

cd /root
useradd centos
echo 'ddxd2015' | passwd --stdin centos

# 为centos增加sudo权限
cp /etc/sudoers /etc/sudoers_$(date +'%Y%m%d%H%M%S').bak
cat << EOF >> /etc/sudoers

## custom configuration for centos
## Allow centos to run any commands anywhere
centos    ALL=(ALL)       ALL
EOF
#sed -i '/secure_path/{s#$#:/usr/local/bin#}' /etc/sudoers #安全路径中增加/usr/local/bin

mkdir -p /data/log
mkdir -p /data/backup
mkdir -p /data/redis

## 安装nginx
cat << 'EOF' > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=1
enabled=1
EOF

wget http://nginx.org/keys/nginx_signing.key
rpm --import nginx_signing.key
yum -y update && yum install -y nginx


## 安装mongodb
cat << 'EOF' > /etc/yum.repos.d/mongodb-org-3.2.repo
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
EOF

yum -y update && yum install -y mongodb-org

## 通过源代码安装redis
yum install -y tcl #安装tcl依赖

cd /data/backup
wget http://download.redis.io/releases/redis-3.0.7.tar.gz
tar xvfz redis-3.0.7.tar.gz
cd redis-3.0.7

make
make test
make install

# 设置自动启动脚本
cd utils
./install_server.sh

# redis的相关配置
#Port           : 6379
#Config file    : /etc/redis.conf
#Log file       : /data/log/redis.log
#Data dir       : /data/redis
#Executable     : /usr/bin/redis-server
#Cli Executable : /usr/bin/redis-cli

# 修改服务名 redis_6379 => redis
cp /etc/init.d/redis_6379 /etc/init.d/redis
chkconfig --add redis
chkconfig --del redis_6379
rm /etc/init.d/redis_6379
service redis restart

# 将data目录的所有者修改为centos
chown -R centos:centos /data

## CENTOS_CMD中的内容由centos用户来执行
read -r -d '' CENTOS_CMD << 'HERE_DOC'
mkdir ~/.ssh
chmod -R 700 ~/.ssh
cat << EOF >> ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4EWdOtLSaqEWpUYmdN0FwsTqyHBItiJLXj10zrHHQVoa7AU1DFQFNnXglEtXFRsxBYc0uPkl5ib77LV1npUkZCg9LTbjoz8LVkIHGOXkjrBLt6QyZZYFZm6RQ8OoiGSwYvsy2zCsK5SRVruqmcDznYawHacI1mF+u6PSwiubM8FgQe+c3sUyOTF8Thp0Wb6nXx/c75JD+NlSjc6kEnh7Fb2EYsYIDog+rhMS+QXnAjt4pEstouKq2Mci0LLdrJbuam9RSfChbowpUWe/JAck5qG5HPrZDm7H8AjoTOeNlLgC/Vg3C5qZdfkCUpjC1G0IXjBQWFbQJfMQSwJVTOYQJ dd-b1@TT-DDX-MacMini.local
EOF
chmod 600 ~/.ssh/authorized_keys

cat << 'EOF' >> ~/.bashrc

# custom configuration for centos
if [ "$PS1" ]; then
  complete -cf sudo
fi

export EDITOR=vim
export VISUAL=vim

export NODE_ENV=development
alias npm='npm --registry=https://registry.npm.taobao.org'

alias redis-cli='redis-cli --raw' #让redis-cli正常显示中文
EOF

# 检查环境，必须装有sslocal和polipo，否则直接退出
command -v sslocal >/dev/null 2>&1 || { echo >&2 "require sslocal but it's not installed. Aborting."; exit 1; }
command -v polipo >/dev/null 2>&1 || { echo >&2 "require polipo but it's not installed. Aborting."; exit 1; }

# 利用nvm安装node
export http_proxy=http://127.0.0.1:8123 #需要先安装polipo的代理
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
. ~/.bashrc #使nvm命令生效
nvm install 4.4.0
nvm alias default 4.4.0
npm install --verbose -g pm2

## clone
cd ~
git clone https://github.com/lutaoact/some_config.git
ln -sf ~/some_config/vimrc     ~/.vimrc
ln -sf ~/some_config/gitconfig ~/.gitconfig
sed -i '/credential\|osxkeychain/d' ~/some_config/gitconfig
HERE_DOC

su --login centos -c "$CENTOS_CMD" #以centos用户来执行命令
