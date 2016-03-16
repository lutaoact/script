#!/bin/bash
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

# 安装nginx
cat << 'EOF' > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF

wget http://nginx.org/keys/nginx_signing.key
rpm --import nginx_signing.key
yum update && yum install -y nginx


# 安装mongodb
cat << 'EOF' > /etc/yum.repos.d/mongodb-org-3.2.repo
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
EOF

yum update && yum install -y mongodb-org

# 通过源代码安装redis
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

# 修改服务名 redis_6379 => redis
cp /etc/init.d/redis_6379 /etc/init.d/redis
chkconfig --add redis
chkconfig --del redis_6379
service redis restart

# 将data目录的所有者修改为centos
chown -R centos:centos /data

# 切换到centos用户
su centos
cd /home/centos

mkdir /home/centos/.ssh
chmod -R 700 /home/centos/.ssh
cat << EOF >> /home/centos/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4EWdOtLSaqEWpUYmdN0FwsTqyHBItiJLXj10zrHHQVoa7AU1DFQFNnXglEtXFRsxBYc0uPkl5ib77LV1npUkZCg9LTbjoz8LVkIHGOXkjrBLt6QyZZYFZm6RQ8OoiGSwYvsy2zCsK5SRVruqmcDznYawHacI1mF+u6PSwiubM8FgQe+c3sUyOTF8Thp0Wb6nXx/c75JD+NlSjc6kEnh7Fb2EYsYIDog+rhMS+QXnAjt4pEstouKq2Mci0LLdrJbuam9RSfChbowpUWe/JAck5qG5HPrZDm7H8AjoTOeNlLgC/Vg3C5qZdfkCUpjC1G0IXjBQWFbQJfMQSwJVTOYQJ dd-b1@TT-DDX-MacMini.local
EOF
chmod 600 /home/centos/.ssh/authorized_keys

cat << 'EOF' >> /home/centos/.bashrc

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

. ~/.bashrc

# 利用nvm安装node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
nvm install 4.4.0
nvm alias default 4.4.0
npm install -g pm2


echo 'clone node-server...'
git clone https://lutaoact@bitbucket.org/lutaoact/node-server.git
cd node-server
npm --verbose install

git clone https://github.com/lutaoact/some_config.git
ln -sf /home/centos/some_config/vimrc /home/centos/.vimrc
ln -sf /home/centos/some_config/gitconfig /home/centos/.gitconfig
