awk '{print $1, $3}' netstat.txt
awk '{printf "%-8s %-8s %-8s %-18s %-22s %-15s\n",$1,$2,$3,$4,$5,$6}' netstat.txt
awk '$3 == 0 && $6 == "LAST_ACK"' netstat.txt
