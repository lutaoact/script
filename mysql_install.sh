# 参考网址 https://dev.mysql.com/doc/mysql-repo-excerpt/5.6/en/linux-installation-yum-repo.html
wget 'https://repo.mysql.com/mysql57-community-release-el6-9.noarch.rpm'

sudo yum localinstall mysql57-community-release-el6-9.noarch.rpm

sudo yum-config-manager --disable mysql57-community
sudo yum-config-manager --enable mysql56-community

yum repolist enabled | grep mysql

sudo yum install mysql-community-server

sudo service mysqld start
sudo service mysqld restart

#PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
#To do so, start the server, then issue the following commands:
#
#  /usr/bin/mysqladmin -u root password 'new-password'
#  /usr/bin/mysqladmin -u root -h iZ23xd5pqd6Z password 'new-password'
#
#Alternatively you can run:
#
#  /usr/bin/mysql_secure_installation

# mysql创建用户语句
CREATE USER 'kz'@'localhost' IDENTIFIED BY 'ddxd2015';
GRANT ALL PRIVILEGES ON *.* TO 'kz'@'localhost' WITH GRANT OPTION;

CREATE USER 'kz'@'%' IDENTIFIED BY 'ddxd2015';
GRANT ALL PRIVILEGES ON *.* TO 'kz'@'%' WITH GRANT OPTION;
