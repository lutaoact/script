#!/bin/bash
awk '{print substr($3, 4)}' /tmp/myself.txt | sed 's/,//g' | awk '{sum += $1 * 100}END{print sum}'

# 201710 8939.53
