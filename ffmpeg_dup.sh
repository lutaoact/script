
ffprobe -hide_banner -v quiet -show_streams /data/videos/input_bak/sxc_147904279442.mp4 | grep -E '^(width|height)'
ffmpeg -ss 10 -i /data/videos/input_bak/sxc_147904279442.mp4 -vframes 1 -filter_complex "[0]crop=1440:1080:240:0,scale=1280:720,setsar=1" -q:v 2 -pix_fmt yuvj420p 1.jpg

ffmpeg -t 5 -i /data/videos/input_bak/sxc_147904338324.mp4 12s$(date +%m%d%H%M).mp4
ffmpeg -hide_banner -loglevel panic -y -i /data/videos/input_bak/sxc_147904279442.mp4 -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0]crop=1440:1080:240:0,scale=1280:720,setsar=1[bg];[bg][1]overlay=0:-4[v1];[v1][3]overlay=main_w-overlay_w+2:main_h-overlay_h+2[v3];[v3][4]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart sxc_147904279442.mp4
ffmpeg -hide_banner -loglevel panic -y -i 12s07011919.mp4 -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0]crop=1440:1080:240:0,scale=1280:720,setsar=1[bg];[bg][1]overlay=0:-4[v1];[v1][3]overlay=main_w-overlay_w+2:main_h-overlay_h+2[v3];[v3][4]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4

# 处理那种处在右边中间的视频 300x230
ffmpeg -hide_banner -loglevel panic -y -i /data/videos/sxc_148236441731.mp4 -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0]scale=1280:720,setsar=1[bg];[bg][1]overlay=0:-4[v1];[2]scale=305:235[s2];[v1][s2]overlay=978:143[v2];[v2][3]overlay=main_w-overlay_w+2:main_h-overlay_h+2[v3];[v3][4]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180701/sxc_148236441731.mp4

for i in sxc_147904279442.mp4 sxc_147904338324.mp4; do
  ffmpeg -hide_banner -loglevel panic -y -i /data/videos/input_bak/$i -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0]crop=1440:1080:240:0,scale=1280:720,setsar=1[bg];[bg][1]overlay=0:-4[v1];[v1][3]overlay=main_w-overlay_w+2:main_h-overlay_h+2[v3];[v3][4]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180503/$i
done

# 处理未处理妥当的视频，只覆盖右上角
ffmpeg -hide_banner -loglevel panic -y -i sxc_146952623220.mp4 -i right_top.png -filter_complex "[1]scale=360:270[s1];[0][s1]overlay=921:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4
ffmpeg -hide_banner -loglevel panic -y -i 12s07011740.mp4 -i right_top.png -filter_complex "[1]scale=360:270[s1];[0][s1]overlay=921:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4
ffmpeg -hide_banner -loglevel panic -y -i /data/backup/done20180503/sxc_147322124938.mp4 -i right_top.png -filter_complex "[1]scale=390:295[s1];[0][s1]overlay=891:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output/sxc_147322124938.mp4
  ffmpeg -hide_banner -loglevel panic -y -i /data/backup/done20180503/$i -i right_top.png -filter_complex "[1]scale=360:270[s1];[0][s1]overlay=921:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180503/$i


for i in sxc_147407098940.mp4 sxc_147407153371.mp4 sxc_147407177675.mp4 sxc_147407183538.mp4 sxc_147407221073.mp4 sxc_147407249828.mp4 sxc_147407256478.mp4 sxc_147407279495.mp4; do
  ffmpeg -hide_banner -loglevel panic -y -i /data/backup/done20180503/$i -i right_top.png -filter_complex "[1]scale=390:295[s1];[0][s1]overlay=891:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180503/$i
done

for i in sxc_147408054186.mp4 sxc_149693037272.mp4; do
  ffmpeg -hide_banner -loglevel panic -y -i /data/backup/done20180503/$i -i right_top.png -filter_complex "[1]scale=362:272[s1];[0][s1]overlay=921:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180503-360x270/$i
done

for i in sxc_147935671250.mp4 sxc_147972181719.mp4; do
  ffmpeg -hide_banner -loglevel panic -y -i /data/backup/done20180503/$i -i right_top.png -filter_complex "[1]scale=460:350[s1];[0][s1]overlay=821:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180503-460x350/$i
done

for i in sxc_149563757881.mp4; do
  ffmpeg -hide_banner -loglevel panic -y -i /data/backup/done20180503/$i -i right_top.png -filter_complex "[1]scale=415:315[s1];[0][s1]overlay=865:-1[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p -movflags +faststart /data/videos/output20180503-415x315/$i
done
