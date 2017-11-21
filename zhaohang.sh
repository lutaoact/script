#!/bin/bash
awk '{sum += $1 * 100}END{print sum, sum / 100}' /tmp/zhaohang.txt

# 201711 949082 9490.82
