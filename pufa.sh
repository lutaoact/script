#!/bin/bash
ack '^0471.*支付宝' /data/backup/pufa.txt | tee /data/backup/0471.txt | awk '{print substr($3, 4)}' | sed 's/,//g' | awk '{sum += $1 * 100}END{printf "%d %d.%02d\n", sum, int(sum / 100), sum % 100}'

# diff <(cat 0471.txt) <(grep 0471 tmp.txt)
# diff <(cat 0471.txt) <(cat 0471.txt | ack '0471.*支付宝 消费.*保险')
# 201710 55580.98
# 201711 5967228 59672.28
# 201712 3690282 36902.82
