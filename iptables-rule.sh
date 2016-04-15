#!/bin/bash

iptables -F
iptables -X
iptables -Z

iptables -P INPUT   DROP
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT

iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLI -j ACCEPT

iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT

/etc/init.d/iptables save
