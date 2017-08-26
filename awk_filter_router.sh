ack router.get routes/* | awk '
  BEGIN {
    FS=":"
  }
  {
    if ($1 == "routes/sync.js") next;
    if ($1 == "routes/ex.js") next;

    a = substr($1, 8, length($1) - 10);
    if (match($3, /\047.*\047/)) {
#      print RSTART, RLENGTH;
      b = substr($3, RSTART + 1, RLENGTH - 2);

      if (a == "index") {
        print b;
        next;
      }

      if ($3 ~ "auth") {
        print "/"a"s"b" auth";
      } else {
        print "/"a"s"b;
      }
    }
#    print $3;
  }
'
