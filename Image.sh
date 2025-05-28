-- 选择文件夹
set folderPath to (choose folder with prompt "请选择需要处理的文件夹") as text

-- 设置宽度
set newWidth to "1600"

-- 记录开始时间
set startTime to (current date)

-- 将路径转换为 POSIX 格式
set folderPathPOSIX to POSIX path of folderPath

-- 设置 PATH 并调用 shell 脚本
do shell script "
export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH
find " & quoted form of folderPathPOSIX & " -type f \\( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \\) | while read file; do
    mogrify -resize " & newWidth & "x \"$file\"
done
"

-- 记录结束时间
set endTime to (current date)

-- 计算运行时间（秒）
set elapsedTime to (endTime - startTime)

-- 将运行时间格式化为 "分:秒"
set elapsedMinutes to (elapsedTime div 60) as integer
set elapsedSeconds to (elapsedTime mod 60) as integer
set elapsedTimeFormatted to elapsedMinutes & " 分 " & elapsedSeconds & " 秒"

-- 显示处理完成的提示
display dialog "图片处理完成！
文件夹路径: " & folderPath & "
总耗时: " & elapsedTimeFormatted & "
完成时间: " & endTime buttons {"OK"} default button "OK"
