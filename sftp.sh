#!/bin/bash
# run as root
mkdir -p /data3/sftpuser

groupadd sftpuser

useradd -g sftpuser -d /upload -s /sbin/nologin sftpuser
passwd sftpuser
# sjtu1896

mkdir -p /data3/sftpuser/upload
chown -R sftpuser:sftpuser /data3/sftpuser

ls -ld /data3/
ls -ld /data3/sftpuser
ls -ld /data3/sftpuser/upload

cat /etc/passwd | grep sftpuser

vi /etc/ssh/sshd_config

#Subsystem sftp internal-sftp
#
#Match Group sftpuser
#ChrootDirectory /data3/%u
#ForceCommand internal-sftp
