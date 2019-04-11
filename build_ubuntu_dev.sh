#!/bin/bash -xv

apt -y update && apt -y install tmux

useradd -m -s /bin/bash ubuntu
echo 'ddxd2015' | passwd --stdin ubuntu

useradd -m -s /bin/bash lutao
echo lutao:iamok | /usr/sbin/chpasswd

# 加入到 sudo 组中，使 ubuntu 用户拥有 sudo 权限
usermod -aG sudo ubuntu

# 禁用 root 用户登录
sed -i.bak '/PermitRootLogin/c PermitRootLogin no' /etc/ssh/sshd_config
systemctl restart sshd

mkdir -p /data/log /data/backup /data/tmp /data/redis
chown -R ubuntu:ubuntu /data

UBUNTU_CODENAME=$(lsb_release -cs)

## 安装nginx
cat << EOF >> /etc/apt/sources.list
deb http://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx
deb-src http://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx
EOF

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
apt update && apt install -y nginx

## 安装mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
apt update && apt install -y mongodb-org
systemctl enable mongod && systemctl start mongod

## 通过源代码安装redis
apt install -y tcl #安装tcl依赖

cd /data/backup
wget http://download.redis.io/releases/redis-4.0.8.tar.gz
tar xzf redis-4.0.8.tar.gz
cd redis-4.0.8
make && make test && make install

# 设置自动启动脚本
cd utils
./install_server.sh

# redis的相关配置
#Port           : 6379
#Config file    : /etc/redis/6379.conf
#Log file       : /data/log/redis.log
#Data dir       : /data/redis
#Executable     : /usr/bin/redis-server
#Cli Executable : /usr/bin/redis-cli

# 修改服务名 redis_6379 => redis
cp /etc/init.d/redis_6379 /etc/init.d/redis
chkconfig --add redis
chkconfig --del redis_6379
rm -f /etc/init.d/redis_6379
service redis restart

## CENTOS_CMD中的内容由centos用户来执行
read -r -d '' CENTOS_CMD << 'HERE_DOC'
mkdir ~/.ssh
chmod -R 700 ~/.ssh
cat << EOF > ~/.ssh/authorized_keys
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
alias pm2="pm2 --log-date-format 'YYYY-MM-DDTHH:mm:ssZ'"

alias redis-cli='redis-cli --raw' #让redis-cli正常显示中文
EOF

# 检查环境，必须装有sslocal和polipo，否则直接退出
# command -v sslocal >/dev/null 2>&1 || { echo >&2 "require sslocal but it's not installed. Aborting."; exit 1; }
# command -v polipo >/dev/null 2>&1 || { echo >&2 "require polipo but it's not installed. Aborting."; exit 1; }
# export http_proxy=http://127.0.0.1:8123 #需要先安装polipo的代理

# 利用nvm安装node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
. ~/.bashrc #使nvm命令生效
nvm install 4.4
nvm alias default 4.4
npm install --verbose -g pm2

## clone
cd ~
git clone https://github.com/lutaoact/some_config.git
ln -sf ~/some_config/vimrc     ~/.vimrc
ln -sf ~/some_config/gitconfig ~/.gitconfig
sed -i 's/osxkeychain/cache --timeout=864000/' ~/some_config/gitconfig
sed -i '/http\|proxy/d' ~/some_config/gitconfig

# 导入bitbucket的key，然后clone node-server库
cat << EOF > ~/.ssh/bitbucket.job.pem
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA0spqj8FAcHxoOjhbqenKFbiUUGdmHs1rqud1xBgaSnJ2uu0w
SylcwFQzdwsj52s3XkNrs2WljJxQArr+tLShjiTeFpfr6s2I6W+RA8eWheW8MZlt
s8G9e0l8iFtuKDIywbqgKhEfUaxcaA7Jnxht0jjgEE3c50g+ZykCXcPXvN/almHM
jpCu7ibDEwtXwdB6hbDswtdLyK8L9I9eZr0BoSuTb2oAI5lc/8x6ZjBi9Hr4PDWn
EZcTLv0Nm7Gv3fRmBmnXjWsdkCY5rEI7nqJOXeBRt4WrT0pNgi7knmVHLczvPi63
4OMEWizkYmNwEds1E/W8AUNYI9LF114AycDUHQIDAQABAoIBAAS1cNv1PTNGFC34
xFNvXYxOq0GAjc9yV01iDkdrIms3U1+pnMKREflZ6Cxom0y4IGyCpQ1E4AXcGA13
j+kJf/Jk8HEgw6xjGwPb8ilbdAlZsHKLMuApG8p9QcLqB/Pt6yRYvusxprl0WDwa
2HYtXYasrpSuqJiiDILRb7QYg+E8NIFeOCSzcv7TzRzfW1nBUEaED5Y1ljhkXYPb
BTJ+cOEnJvBNkrmw3W8nOzvsMsXL8zlf1hHgXaZKE+37qIcTxRZ1LQiEafKi7BlP
7FaWC7r9PPstIa1NuMNXSRBIfjICCqV4XXftO4f3nwIefPQabzJXUf2BRyOKmQOE
9rHjSCECgYEA/wGPZMlcfHL2K+MR2dJUr8rdLArDLZ9V5bvpZgdldaQpWiy1yueA
E3qqkGPozAgdCMRCUmhdK6DtTY5/iAw/uHJNxzSiCA1+K3GVwfLR2PqmBxqfQLdp
+CloC43nBEOOg6cSsN30ph16Vx0zq9jnTAwqH8pC+njJkdj8Xei7XCsCgYEA05y9
KE8RRxEVUoXs3N3hjptK/d++Aolrs3jniOUAOYYYlxUmY4cDDsNEeCVaAOQyZAuz
FAMHoHIhjEgFpqQwc9V2YeMGNHPQ2FSMthW234YH75yH10g+ZfKl5yECBlMe1Jf7
VrK4muE3oIz3+O2E0dAZMQ3clMgb/cP7IPtBRNcCgYEArJQguGPyPKMM6RyumwzW
lXYkgsbx2nFoD6dByPQefSRRfB6gFabgrc4pmriS92pSQ/mWrPDGhV1O3FshAjDP
+wMYkkWTlwGSrtIbOPwdesv/CvXAa2r1w6Y6LP+nJeKWk5DBfINqK/XtMwGnU5ji
yDu/Um5vL9YJDLSd7uwvyKsCgYEArVVsFAKAEohJwOj2lgwhYCCQEtgc2hMaZ04X
yahawMO4jLjEUy4aMRN9mDRwPt6s8AotS60XqDMUi8XK6y7+iUNGzvOY94oOfcTz
5Ypv2zP8eCbtlkgU5IkXn/UHpYqcbGN5exC16hek6xvNWtejvgEJQYcrMaugUgMg
R2nHks0CgYEA+yL4hncSl1cLKmVHFaRVqyTrsXo4IKeWn9ZG2kolKF9mqWzM79hN
cE3Sa+YD1/W3P6XWCRg5c2Xb3MTfMz3DrNHu5UECKf8oxPI7biYwy94fXq1aCeS8
4g8AO4F5n8l1LZSTpov9YxNrJm8M2LmDIJlNDYBpPhVlXZKwJEKujOw=
-----END RSA PRIVATE KEY-----
EOF

cat << EOF > ~/.ssh/config
ServerAliveInterval 60

Host bitbucket.org
    Hostname bitbucket.org
    User git
    IdentityFile ~/.ssh/bitbucket.job.pem
    StrictHostKeyChecking no
EOF
chmod 600 ~/.ssh/*

git clone git@bitbucket.org:lutaoact/node-server.git
HERE_DOC

su --login centos -c "$CENTOS_CMD" #以centos用户来执行命令

