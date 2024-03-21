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
docker pull nezha123/titan-edge:1.2


# 创建用户指定数量的容器
for i in $(seq 1 $container_count)
do
    # 为每个容器创建一个存储卷
    storage="titan_storage_$i"
    mkdir -p "$storage"

    # 运行容器，并设置重启策略为always
    container_id=$(docker run -d --restart always -v "$PWD/$storage:/root/.titanedge/storage" --name "titan$i" nezha123/titan-edge:1.2)

    echo "节点 titan$i 已经启动 容器ID $container_id"

    sleep 30
    
    # 进入容器并执行绑定和其他命令
    docker exec -it $container_id bash -c "\
        titan-edge bind --hash=$id https://api-test1.container1.titannet.io/api/v2/device/binding"
done

echo "==============================所有节点均已设置并启动===================================."
