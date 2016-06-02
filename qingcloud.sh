#!/bin/bash

qingcloud iaas describe-instances #获取主机列表
qingcloud iaas start-instances --instances i-1duawxmn #开启主机
qingcloud iaas restart-instances --instances i-1duawxmn #开启主机
