#!/bin/bash
awk '{sum += $1 * 100}END{print sum, int(sum / 100)"."sum % 100}' /data/backup/zhaohang.txt

# 201711 949082 9490.82
