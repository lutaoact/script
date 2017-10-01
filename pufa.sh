ack '支付宝 消费.*保险.*0471' | awk '{print substr($6, 4)}' | sed 's/,//g' | awk '{sum += $1 * 100}END{print sum}'
