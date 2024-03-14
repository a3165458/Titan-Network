#!/bin/bash

# 脚本保存路径
SCRIPT_PATH="$HOME/Titan.sh"

# 函数定义
start_node() {
    if [ "$1" = "first-time" ]; then
        echo "首次启动节点..."
        # 下载并解压 titan-node 到 /usr/local/bin
        echo "正在下载并解压 titan-node..."
        wget -c https://github.com/Titannet-dao/titan-node/releases/download/0.1.12/titan_v0.1.12_linux_amd64.tar.gz -O - | sudo tar -xz -C /usr/local/bin --strip-components=1
        titan-edge daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0
    else
        echo "启动节点..."
        titan-edge daemon start
    fi
}

bind_node() {
    echo "绑定节点..."
    read -p "请输入身份码: " identity_code
    echo "绑定节点，身份码为: $identity_code ..."
    titan-edge bind --hash=$identity_code https://api-test1.container1.titannet.io/api/v2/device/binding
}

stop_node() {
    echo "停止节点..."
    titan-edge daemon stop
}

# 主菜单
function main_menu() {
    clear
    echo "脚本以及教程由推特用户大赌哥 @y95277777 编写，免费开源，请勿相信收费"
    echo "================================================================"
    echo "节点社区 Telegram 群组:https://t.me/niuwuriji"
    echo "节点社区 Telegram 频道:https://t.me/niuwuriji"
    echo "首次安装节点后，等待生成文件（大约1-2分钟），敲击键盘ctrl c 停止节点，绑定身份码，再运行启动节点即可"
    echo "请选择要执行的操作:"
    echo "1) 安装节点"
    echo "2) 启动节点"
    echo "3) 绑定节点"
    echo "4) 停止节点"
    read -p "输入选择 (1-5): " choice

    case $choice in
        1)
            start_node first-time
            ;;
        2)
            start_node
            ;;
        3)
            bind_node
            ;;
        4)
            stop_node
            ;;
        *)
            echo "无效输入，请重新输入."
            ;;
    esac
}

# 显示主菜单
main_menu
