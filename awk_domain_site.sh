awk '
  FNR == NR {domain[$1] = 0; next}
  {
    for (dom in domain) {
      if (match($1, dom "$")) {
        domain[dom] += $2
        break
      }
    }
  }
  END {for (dom in domain) {print dom, domain[dom]}}
' domain site

#或者也可以用$1 ~ dom "$"
