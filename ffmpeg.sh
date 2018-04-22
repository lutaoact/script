ffmpeg -i long_sample.mp4 -vf "transpose=1" -c:a copy out.mov

# 逆时针旋转270度
ffmpeg -i long_sample.mp4 -map_metadata 0 -metadata:s:v rotate="90" -codec copy output.mp4

ffmpeg -i long_sample.mp4 -map_metadata 0 -metadata:s:v rotate="270" -codec copy output270.mp4

ffmpeg -i 2018Demo-HD-1080p.mov -map_metadata 0 -metadata:s:v rotate="270" -codec copy 2018Demo-HD-1080p-rotate270.mov

# 从 mov 转成 mp4
ffmpeg -i 2018Demo-HD-1080p.mov -vcodec copy -acodec copy 2018Demo-HD-1080p.mp4

# 从 mov 转成 mp4，并逆时针旋转270度
ffmpeg -i 2018Demo-HD-1080p.mov -map_metadata 0 -metadata:s:v rotate="270" -codec copy 2018Demo-HD-1080p-rotate270.mp4
ffmpeg -i 2018Demo-480p.mov -map_metadata 0 -metadata:s:v rotate="270" -codec copy 2018Demo-480p-rotate270.mp4
ffmpeg -i 2018Demo-720p.mov -map_metadata 0 -metadata:s:v rotate="270" -codec copy 2018Demo-720p-rotate270.mp4

# 原命令
ffmpeg -i ./qshell/home.mov -s hd720 -b 384k -vcodec libx264 -r 23.976 -acodec libfaac -ac 2 -ar 44100 -ab 64k -profile:v baseline -crf 22 -deinterlace 2.mp4

# 改进版
ffmpeg -i ./qshell/home.mov -s hd720 -b:v 384k -vcodec libx264 -r 23.976 -c:a aac -ac 2 -ar 44100 -ab 64k -profile:v baseline -pix_fmt yuv420p -crf 22 -deinterlace 2.mp4

# 无声版
ffmpeg -i ./qshell/home.mov -s hd720 -b:v 384k -vcodec libx264 -r 24 -an -profile:v baseline -pix_fmt yuv420p -crf 22 -deinterlace 2.no.audio.mp4
ffmpeg -i ./qshell/home.mov -s hd720 -b:v 256k -vcodec libx264 -r 24 -an -profile:v baseline -pix_fmt yuv420p -crf 24 -deinterlace 2.no.audio.mp4

ffmpeg -i ./qshell/home.mov -s hd720 -b:v 256k -c:v libx264 -preset veryslow -profile:v baseline -pix_fmt yuv420p -crf 30 -deinterlace -an $(date +'%H%M%S').mp4

# -b:v 384k 视频比特率为 384k
# -crf Constant Rate Factor 取值范围0~51，其中0为无损模式，数值越大，画质越差，生成的文件却越小。从主观上讲，18~28是一个合理的范围，18被认为是视觉无损的


ffmpeg -i MainVideo.avi
-f gdigrab -framerate 25 -video_size 300x200 -i title="MyWindow"
-filter_complex "[0]setpts=PTS-STARTPTS[b];[b][1:v]overlay=(main_w-overlay_w):main_h-overlay_h[v]"
-map "[v]" -c:v libx264 -r 25 out.mp4

ffmpeg -i 1.mp4 -f gdigrab -framerate 25 -video_size 300x200 -i title="MyWindow"
-filter_complex
"[1]split[m][a];
 [a]format=yuv444p,geq='if(gt(lum(X,Y),0),255,0)',hue=s=0[al];
 [m][al]alphamerge[ovr];
 [0][ovr]overlay=(main_w-overlay_w):main_h-overlay_h[v]"
-map "[v]" -c:v libx264 -r 25 out.mp4

# 原始命令 覆盖一张图片，只覆盖0-20秒之间的视频
ffmpeg -i input.mp4 -i image.png \
-filter_complex "[0:v][1:v] overlay=25:25:enable='between(t,0,20)'" \
-pix_fmt yuv420p -c:a copy \
output.mp4

ffmpeg -t 00:00:05 -i sxc_151563951045.mp4 sample.mp4
ffmpeg -t 00:00:05 -i sxc_151444152211.mp4 input2.mp4
ffmpeg -t 00:00:05 -i filter3.mp4 input3.mp4

# 在指定位置上覆盖一张图片
ffmpeg -i sxc_151563951045.mp4 -i image.jpg -filter_complex "[0:v][1:v] overlay=25:25" -pix_fmt yuv420p -c:a copy output.mp4
ffmpeg -i input.mp4 -i logo_156x164.png -filter_complex "[0:v][1:v] overlay=10:7" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4

ffmpeg -i input.mp4 -i circle3.png -filter_complex "[0:v][1:v] overlay=10:7" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4
ffmpeg -i input.mp4 -i left_top.png -filter_complex "[0:v][1:v] overlay=0:0" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4 #左上角定稿
ffmpeg -i sxc_151563951045.mp4 -i left_top.png -filter_complex "[0:v][1:v] overlay=0:0" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4 #左上角定稿

ffmpeg -i input.mp4 -i left_top.png -i right_top_361x271.png -filter_complex "[0][1]overlay=0:0[v1];[v1][2]overlay=919:0[v2]" -map "[v2]" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4
ffmpeg -i input.mp4 -i left_top.png -i right_top_365x275.png -filter_complex "[0][1]overlay=0:0[v1];[v1][2]overlay=919:0[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p output$(date +%H%M%S).mp4
ffmpeg -i sxc_151563951045.mp4 -i left_top.png -i right_top_365x275.png -filter_complex "[0][1]overlay=0:0[v1];[v1][2]overlay=919:0[v2]" -map "[v2]" -map 0:a -pix_fmt yuv420p output$(date +%H%M%S).mp4 #右上角定稿

ffmpeg -i input.mp4 -i left_top.png -i right_top_365x275.png -i right_bottom_362x62.png -filter_complex "[0][1]overlay=0:0[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3]" -map "[v3]" -map 0:a -pix_fmt yuv420p output$(date +%H%M%S).mp4
ffmpeg -i sxc_151563951045.mp4 -i left_top.png -i right_top_365x275.png -i right_bottom_362x62.png -filter_complex "[0][1]overlay=0:0[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3]" -map "[v3]" -map 0:a -pix_fmt yuv420p output$(date +%H%M%S).mp4
ffmpeg -i input.mp4 -i left_top.png -i right_top_365x275_2.png -i right_bottom_362x62_2.png -filter_complex "[0][1]overlay=0:-4[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3]" -map "[v3]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M%S).mp4 # 右下角定稿
ffmpeg -i sxc_151563951045.mp4 -i left_top.png -i right_top_365x275_2.png -i right_bottom_362x62_2.png -filter_complex "[0][1]overlay=0:-4[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3]" -map "[v3]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4 # 右下角定稿
# When encoding is finished -movflags +faststart will relocate some data to the beginning of the file. This is useful, for example, if you are outputting to MP4 and your viewers will watch via progressive download such as from a browser.
# https://superuser.com/questions/848605/ffmpeg-video-from-single-image-with-multiple-video-overlays

# 右下角定稿 2018-04-21
ffmpeg -i input.mp4 -i left_top.png -i right_top_365x275_2.png -i right_bottom_362x62_2.png -i logo_middle.png -filter_complex "[0][1]overlay=0:-4[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3];[v3][4]overlay=310:130[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4

# 右下角定稿 2018-04-21
ffmpeg -i sxc_151563951045.mp4 -i left_top.png -i right_top_365x275_2.png -i right_bottom_362x62_2.png -i logo_middle.png -filter_complex "[0][1]overlay=0:-4[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3];[v3][4]overlay=310:130[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4
# 处理 1240 * 696 定稿 2018-04-22
ffmpeg -i input2.mp4 -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0][1]overlay=0:-4[v1];[v1][2]overlay=879:0[v2];[v2][3]overlay=889:636[v3];[v3][4]overlay=310:130[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4

# 处理 1920 * 1080 定稿 2018-04-22
ffmpeg -i input3.mp4 -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0:v]scale=1280:-1[bg];[bg][1]overlay=0:-4[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3];[v3][4]overlay=310:130[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4
ffmpeg -i filter3.mp4 -i left_top.png -i right_top.png -i right_bottom.png -i logo_middle.png -filter_complex "[0:v]scale=1280:-1[bg];[bg][1]overlay=0:-4[v1];[v1][2]overlay=919:0[v2];[v2][3]overlay=929:660[v3];[v3][4]overlay=310:130[v4]" -map "[v4]" -map 0:a -pix_fmt yuv420p -movflags +faststart output$(date +%m%d%H%M).mp4

# 定位覆盖图片似乎可以用这种方法，看起来非常不错
ffmpeg -i input.mp4 -i logo.png -filter_complex "[0:v]scale=512:-1[bg];[bg][1:v]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" output
# https://stackoverflow.com/questions/10934420/ffmpeg-how-to-scale-a-video-then-apply-a-watermark

# -map 的使用：https://trac.ffmpeg.org/wiki/Map

# 颜色 383838(262626) 变成353535(232323)
ffmpeg -loop 1 -t 24 -i "image.jpg" -filter_complex "color=000000:s=640x360[bg];[bg][0]overlay=shortest=1:y='min(0,-(t)*26)'" -qscale 1 -y out.mpg

ffmpeg -i moonmen.mp4 -i transparent_overlay.mp4 -filter_complex
"[1]format=rgba,geq=r='r(X,Y)':a='if(between(r(X,Y),77,87)*between(g(X,Y),39,49)*between(b(X,Y),6,16),0,255)'[ovr];
 [0][ovr]overlay"
output.mp4
ffmpeg -i 1.mp4 -i 2.mp4 -filter_complex
"[1]split[m][a];
 [a]geq='if(gt(lum(X,Y),16),255,0)',hue=s=0[al];
 [m][al]alphamerge[ovr];
 [0][ovr]overlay"
output.mp4

ffmpeg -i input.avi
       -vf
       "yadif,format=rgb24,
        lutrgb=r='if(eq(val,0),3,val)':g='if(eq(val,0),3,val)':b='if(eq(val,0),3,val)'"
image%d.png

ffmpeg -i input.mp4 -vf "yadif,format=rgb24,lutrgb=r='if(eq(val,38),35,val)':g='if(eq(val,38),35,val)':b='if(eq(val,38),35,val)'" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4
ffmpeg -i input.mp4 -vf "format=rgb24,lutrgb=r='if(eq(val,38),255,val)':g='if(eq(val,38),255,val)':b='if(eq(val,38),255,val)'" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4
ffmpeg -i input.mp4 -vf "format=rgb24,lutrgb=r='if(lt(val,39),255,val)':g='if(lt(val,39),255,val)':b='if(lt(val,39),255,val)'" -pix_fmt yuv420p -c:a copy output$(date +%H%M%S).mp4

# 探测尺寸
ffprobe -hide_banner -v quiet -show_streams input.mp4 | grep -E '^(width|height)'
size=$(ffprobe -hide_banner -v quiet -show_streams sxc_151444152211.mp4 | grep -E '^(width|height)')
width=$(echo $size | awk '{print $1}' | cut -d= -f2)
height=$(echo $size | awk '{print $2}' | cut -d= -f2)

ffprobe -hide_banner -v quiet -show_streams filter3.mp4 | grep -E '^(width|height)'
