awk '{print substr($NF, 4)}' | awk '/^[0-9]/' | sed 's/,//g' | awk '{sum += $1 * 100}END{print sum}'
