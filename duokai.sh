#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

echo "脚本以及教程由推特用户大赌哥 @y95277777 编写，免费开源，请勿相信收费"
echo "================================================================"
echo "节点社区 Telegram 群组:https://t.me/niuwuriji"
echo "节点社区 Telegram 频道:https://t.me/niuwuriji"

# 读取加载身份码信息
read -p "输入你的身份码: " id

# 让用户输入想要创建的容器数量
read -p "请输入你想要创建的节点数量，单IP限制最多5个节点: " container_count

# 让用户输入想要分配的空间大小
read -p "请输入你想要分配的存储空间大小（GB）: " storage_gb

apt update

# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null
then
    echo "未检测到 Docker，正在安装..."
    apt-get install ca-certificates curl gnupg lsb-release
    
    # 安装 Docker 最新版本
    apt-get install docker.io -y
else
    echo "Docker 已安装。"
fi

# 拉取Docker镜像
docker pull nezha123/titan-edge


# 创建用户指定数量的容器
for i in $(seq 1 $container_count)
do
    # 为每个容器创建一个存储卷
    storage="titan_storage_$i"
    mkdir -p "$storage"
    # 检查 ~/.titanedge 目录是否存在，如果不存在，则创建它
    if [ ! -d "$HOME/.titanedge" ]; then
        mkdir "$HOME/.titanedge"
    fi

    # 运行容器，并设置重启策略为always
    container_id=$(docker run -d --restart always -v "$PWD/$storage:/root/.titanedge/storage" --name "titan$i" nezha123/titan-edge)

    echo "节点 titan$i 已经启动 容器ID $container_id"

    sleep 30
    
    # 进入容器并执行绑定和其他命令
    docker exec -it $container_id bash -c "\
        titan-edge bind --hash=$id https://api-test1.container1.titannet.io/api/v2/device/binding"
done

# 等待足够时间以确保所有容器都已启动并且config.toml文件已经生成
echo "等待所有容器启动并生成配置文件..."
sleep 60

# 修改宿主机上的config.toml文件以设置StorageGB值
config_path="$HOME/.titanedge/config.toml"
if [ -f "$config_path" ]; then
    sed -i '/StorageGB =/c\  StorageGB = '$storage_gb'' "$config_path"
    echo "已将存储空间设置为 $storage_gb GB"
else
    echo "配置文件未找到，可能需要手动设置StorageGB。请检查容器是否正确启动并生成了配置文件。"
fi



echo "==============================所有节点均已设置并启动===================================."
