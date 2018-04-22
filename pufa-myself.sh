#!/bin/bash
awk '{print substr($3, 4)}' /data/backup/myself$(date +%m).txt | sed 's/,//g' | awk '{sum += $1 * 100}END{printf "%d %d.%02d\n", sum, int(sum / 100), sum % 100}'

# 201710 8939.53
# 201710 613766 6137.66
# 201801 372970 3729.70
# 201802 227748 2277.48 zhao 760 zhong 1450 总计4500
