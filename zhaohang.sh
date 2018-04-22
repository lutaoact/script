#!/bin/bash
awk '{sum += $1 * 100}END{printf "%d %d.%02d\n", sum, int(sum / 100), sum % 100}' /data/backup/zhaohang1.txt.bak

# 201711 949082 9490.82
# 201712 9491402 94914.02
# 201712 8353382 83533.82
