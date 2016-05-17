#!/bin/bash

# 构建centos开发环境，基于如下版本：
# lsb_release -a #执行此命令，可以查看版本信息

# LSB Version:    :core-4.1-amd64:core-4.1-noarch
# Distributor ID: CentOS
# Description:    CentOS Linux release 7.2.1511 (Core)
# Release:        7.2.1511
# Codename:       Core

## 一些必须要装的软件
yum -y update
yum -y install tmux && ln -s /usr/bin/true /etc/sysconfig/bash-prompt-screen #软链接是为了解决tmux窗口名称被莫名重置的问题

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

# 禁用root用户登录
#sed -i.bak '/PermitRootLogin/c PermitRootLogin no' /etc/ssh/sshd_config
#service sshd restart

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

#export PS1='[\u@dev \W]\$ '
EOF

cd ~
git clone https://github.com/lutaoact/some_config.git
ln -sf ~/some_config/vimrc     ~/.vimrc
ln -sf ~/some_config/gitconfig ~/.gitconfig
sed -i 's/osxkeychain/cache --timeout=864000/' ~/some_config/gitconfig
sed -i '/http\|proxy/d' ~/some_config/gitconfig
HERE_DOC

su --login centos -c "$CENTOS_CMD" #以centos用户来执行命令
