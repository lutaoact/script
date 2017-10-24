#!/bin/bash
ack '0471.*支付宝 消费.*保险' /tmp/0471.txt | awk '{print substr($3, 4)}' | sed 's/,//g' | awk '{sum += $1 * 100}END{print sum}'

# diff <(cat 0471.txt) <(grep 0471 tmp.txt)
# diff <(cat 0471.txt) <(cat 0471.txt | ack '0471.*支付宝 消费.*保险')
# 201710 55580.98
