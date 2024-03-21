#!/bin/bash

# 指定需要删除 .car 文件的目录列表
directories=("titan_storage_1" "titan_storage_2" "titan_storage_3" "titan_storage_4" "titan_storage_5")

# 遍历目录列表
for directory in "${directories[@]}"; do
    directory_path="${directory}/assets"
    
    # 检查目录是否存在
    if [ -d "$directory_path" ]; then
        echo "Deleting .car files in directory: $directory_path"
        
        # 删除目录下所有后缀为 .car 的文件
        find "$directory_path" -type f -name "*.car" -exec rm {} \;
    else
        echo "Directory not found: $directory_path"
    fi
done
