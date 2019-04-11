for i in $(cat /data/videos/videos2.txt); do
  grep "$i" videos.all.sorted.uppercase.flv.txt
done

for i in $(cat /data/videos/tmp.txt); do
  grep "$i" videos.all.sorted.uppercase.flv.txt
done

for i in sxc_147255657110.mp4 sxc_147255671389.mp4; do
  mv input_bak/$i input/$i
done

for i in sxc_147373077982.mp4  sxc_147373122092.mp4; do
  mv input_bak/$i input/$i
done

cd /data/videos/output20180715
for i in $(cat /data/videos/upload.list.20180715095500.txt); do
  qshell fput siyuan "video/$i" "$i" true
done
