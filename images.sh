#!/bin/bash

read -p "请输入要处理的文件夹路径: " source_dir
if [ ! -d "$source_dir" ]; then
  echo "❌ 输入路径无效"
  exit 1
fi

output_dir="$source_dir/CaptureOne"
mkdir -p "$output_dir"

find "$source_dir" -type f | while read file; do
  ext="${file##*.}"
  ext_lower=$(echo "$ext" | tr 'A-Z' 'a-z')
  filename=$(basename "$file")
  name_no_ext="${filename%.*}"
  output_file="$output_dir/$name_no_ext.jpg"

  case "$ext_lower" in
    heic)
      # macOS 原生支持
      if sips -s format jpeg "$file" --out "$output_file" >/dev/null 2>&1; then
        echo "✅ HEIC 转换成功：$output_file"
      else
        echo "❌ HEIC 转换失败：$file"
      fi
      ;;
    tif | tiff)
      # TIF 强制主图层（避免缩略图）
      if magick "$file[0]" "$output_file" >/dev/null 2>&1; then
        echo "✅ TIF 转换成功：$output_file"
      else
        echo "❌ TIF 转换失败：$file"
      fi
      ;;
    raf | cr2 | cr3 | nef | arw | dng | rw2 | orf)
      # RAW 用 dcraw 解码，magick 转 JPG（注意有些相机可能解出黑图）
      if dcraw -c "$file" 2>/dev/null | magick - "$output_file" >/dev/null 2>&1; then
        # 检测是否生成了极小或纯黑的图像
        pixels=$(identify -format "%[fx:w*h]" "$output_file" 2>/dev/null)
        if [[ -z "$pixels" || "$pixels" -lt 10000 ]]; then
          echo "⚠️ 可能黑图或异常图像，请检查：$output_file"
        else
          echo "✅ RAW 转换成功：$output_file"
        fi
      else
        echo "❌ RAW 转换失败：$file"
      fi
      ;;
    *)
      echo "⚠️ 跳过不支持格式：$filename"
      ;;
  esac
done

echo "🎉 所有支持格式处理完成，输出目录：$output_dir"
