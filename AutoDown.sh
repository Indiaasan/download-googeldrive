#!/bin/bash

# 设置要下载的Google Drive链接
drive_link="https://drive.google.com/drive/folders/"

# 设置保存已下载文件夹ID的文件路径
id_file="/root/AutoDown/1.txt"

# 获取当前时间的年月日，例如1101
current_date=$(date +"%m%d")

# 使用wget下载Google Drive链接页面
wget -O "/root/AutoDownSP/temp.html" "https://drive.google.com/drive/folders/folderID"

# 提取页面中所有文件夹的ID，并将它们保存到一个数组中
folder_ids=($(grep -o -E 'https://drive.google.com/drive/folders/[a-zA-Z0-9_-]+' temp.html))

# 获取最后一个文件夹的ID
last_folder_id=${folder_ids[-1]}

# 检查最后一个文件夹的ID是否在1.txt中
if grep -q "$last_folder_id" "$id_file"; then
    echo "ID已存在于1.txt中，无需下载。"
else
    # 构建完整的Google Drive链接
    full_drive_link="$drive_link$last_folder_id"

    # 使用gdown下载最新文件夹
    gdown "$full_drive_link" -O "/var/www/html/path/$current_date" --folder

    cd "/var/www/html/10yue/$current_date"
    tar -cvf 720.tar ./720
    tar -cvf 480.tar ./480
    rm -r ./720
    rm -r ./480
    cd "/root/AutoDownSP"

    # 追加最新文件夹的ID到1.txt
    echo "$last_folder_id" >> "$id_file"
fi

# 删除临时HTML文件
rm /root/AutoDownSP/temp.html
