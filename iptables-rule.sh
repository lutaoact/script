#!/bin/bash

iptables -F
iptables -X
iptables -Z

iptables -P INPUT   DROP
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT

iptables -A INPUT -i enp7s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i enp7s0 -s 192.168.1.0/24 -j ACCEPT

iptables -A INPUT -i enp7s0 -p tcp --dport 62222 -j ACCEPT

iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT

/etc/init.d/iptables save
