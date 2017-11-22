#!/bin/bash
awk '{print substr($3, 4)}' /data/backup/myself.txt | sed 's/,//g' | awk '{sum += $1 * 100}END{print sum, int(sum / 100)"."sum % 100}'

# 201710 8939.53
# 201710 613766 6137.66
