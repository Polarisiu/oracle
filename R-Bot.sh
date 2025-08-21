#!/bin/bash

# =============================
# 颜色定义
# =============================
GREEN="\033[32m"
YELLOW="\033[33m"
PURPLE="\033[35m"
RED="\033[31m"
RESET="\033[0m"

# =============================
# 退出或返回主菜单函数
# =============================
exit_or_main_menu() {
    echo -e "${YELLOW}操作已取消，返回主菜单...${RESET}"
    sleep 1
    main_menu
}

# =============================
# 安装依赖
# =============================
install_dependencies() {
    echo -e "${YELLOW}正在安装依赖...${RESET}"
    apt-get update -y
    apt-get install -y iptables wget nano openjdk-11-jdk
    echo -e "${GREEN}依赖安装完成！${RESET}"
}

# =============================
# 杀掉已存在进程
# =============================
kill_existing_processes() {
    pkill -f sh_client_bot.sh 2>/dev/null
    pid_tail=$(pgrep -f "tail -f /root/rtbot/logs/rtbot.log")
    pid_java=$(pgrep -f java | grep -v grep)

    [[ -n "$pid_tail" ]] && { kill -9 $pid_tail; echo -e "${GREEN}已结束 tail 进程 PID=$pid_tail${RESET}"; }
    [[ -n "$pid_java" ]] && { kill -9 $pid_java; echo -e "${GREEN}已结束 java 进程 PID=$pid_java${RESET}"; }
}

# =============================
# 配置 client_config 文件
# =============================
configure_client() {
    if ! command -v nano &>/dev/null; then
        apt-get install -y nano
    fi

    if [ -f "/root/rtbot/client_config" ]; then
        echo -e "${PURPLE}即将打开 /root/rtbot/client_config 配置文件进行编辑${RESET}"
        echo -e "${PURPLE}请将 username、password 和 API 密钥路径粘贴到指定位置${RESET}"
        echo -e "${PURPLE}保存退出方法：Ctrl+O → Enter → Ctrl+X${RESET}"
        sleep 2
        nano "/root/rtbot/client_config"
        echo -e "${GREEN}client_config 配置更新成功！${RESET}"
    fi
}

# =============================
# 安装并后台运行抢机脚本
# =============================
install_and_run() {
    # =============================
    # 提示用户准备工作
    # =============================
    echo -e "${YELLOW}开始运行抢机脚本前，请完成以下准备工作：${RESET}"
    echo -e "${YELLOW}1：获取R探长机器人对应的${PURPLE}username和password${YELLOW}，机器人获取链接：https://t.me/radiance_helper_bot${RESET}"
    echo ""
    echo -e "${YELLOW}2：获取甲骨文云${PURPLE}API密钥下载文件${YELLOW}并复制内容保存，获取方式在甲骨文云控制台右上角头像--我的概要信息里${RESET}"
    echo ""
    echo -e "${YELLOW}3：将甲骨文云API密钥文件上传至 /root 目录内，并复制文件路径保存到 /root/rtbot/client_config，API密钥最后一行路径改为此路径${RESET}"
    echo -e "${YELLOW}4：请确保你的服务器9527端口可用${RESET}"
    echo ""
    read -p $'\033[1;91m确认了解上述步骤并准备继续运行？[y/n]: \033[0m' confirm
    [[ ! "$confirm" =~ ^[Yy]([Ee][Ss])?$ ]] && exit_or_main_menu

    # =============================
    # 安装依赖
    # =============================
    install_dependencies
    iptables -A INPUT -p tcp --dport 9527 -j ACCEPT

    mkdir -p /root/rtbot/logs && cd /root/rtbot
    kill_existing_processes

    # =============================
    # 下载脚本
    # =============================
    echo -e "${YELLOW}正在下载 sh_client_bot.sh 并准备后台运行...${RESET}"
    wget -O sh_client_bot.sh https://github.com/semicons/java_oci_manage/releases/latest/download/sh_client_bot.sh \
        && chmod +x sh_client_bot.sh

    # =============================
    # 配置 client_config（可选编辑）
    # =============================
    configure_client

    # =============================
    # 后台运行脚本
    # =============================
    echo -e "${GREEN}开始后台执行抢机，并记录日志到 /root/rtbot/logs/rtbot.log ...${RESET}"
    nohup bash sh_client_bot.sh >> /root/rtbot/logs/rtbot.log 2>&1 &
    sleep 2
    echo -e "${GREEN}抢机脚本已在后台运行，可关闭 SSH${RESET}"

    # =============================
    # 后台操作菜单
    # =============================
    while true; do
        echo ""
        echo -e "${YELLOW}操作选项:${RESET}"
        echo -e "1) 配置修改client_config"
        echo -e "2) 重启抢机脚本"
        echo -e "0) 返回主菜单"
        read -p $'\033[1;91m请选择操作: \033[0m' log_choice
        case "$log_choice" in
            1) install_and_run  ;;
            2)
                echo -e "${YELLOW}正在重启抢机脚本...${RESET}"
                pkill -f sh_client_bot.sh 2>/dev/null
                sleep 1
                nohup bash sh_client_bot.sh >> /root/rtbot/logs/rtbot.log 2>&1 &
                echo -e "${GREEN}抢机脚本已重启！${RESET}" ;;
            0) main_menu ;;
            *) echo -e "${RED}无效选项${RESET}" ;;
        esac
    done
}

# =============================
# 查看日志函数
# =============================
view_logs() {
    LOG_FILE="/root/rtbot/logs/rtbot.log"
    if [[ -f "$LOG_FILE" ]]; then
        echo -e "${GREEN}按 q 返回主菜单${RESET}"
        less "$LOG_FILE"
        main_menu
    else
        echo -e "${YELLOW}日志文件不存在，请先运行抢机脚本！${RESET}"
        sleep 2
        main_menu
    fi
}

# =============================
# 查看抢机脚本运行状态
# =============================
check_status() {
    PID=$(pgrep -f sh_client_bot.sh)
    if [[ -n "$PID" ]]; then
        echo -e "${GREEN}抢机脚本正在运行，PID=$PID${RESET}"
    else
        echo -e "${YELLOW}抢机脚本未运行${RESET}"
    fi

    systemctl is-active --quiet rtbot.service \
        && echo -e "${GREEN}systemd 开机自启动：已启用${RESET}" \
        || echo -e "${YELLOW}systemd 开机自启动：未启用${RESET}"

    echo ""
    read -p $'\033[1;91m按回车返回主菜单\033[0m'
    main_menu
}

# =============================
# 一键安全卸载
# =============================
uninstall_bot() {
    echo -e "${YELLOW}正在停止后台抢机脚本...${RESET}"
    pkill -f sh_client_bot.sh 2>/dev/null
    sleep 1

    echo -e "${YELLOW}正在停止并移除 systemd 服务（如果存在）...${RESET}"
    systemctl stop rtbot.service 2>/dev/null
    systemctl disable rtbot.service 2>/dev/null
    rm -f /etc/systemd/system/rtbot.service
    systemctl daemon-reload

    echo -e "${YELLOW}正在删除脚本目录 /root/rtbot ...${RESET}"
    rm -rf /root/rtbot
    sleep 1

    echo -e "${GREEN}卸载完成！后台脚本、日志和开机自启已全部清理。${RESET}"
    read -p $'\033[1;91m按回车返回主菜单\033[0m'
    main_menu
}

# =============================
# 开机自启动功能
# =============================
enable_autostart() {
    SERVICE_FILE="/etc/systemd/system/rtbot.service"

    if [[ ! -f "/root/rtbot/sh_client_bot.sh" ]]; then
        echo -e "${RED}sh_client_bot.sh 不存在，请先安装抢机脚本！${RESET}"
        sleep 2
        main_menu
    fi

    echo -e "${YELLOW}正在创建 systemd 服务以实现开机自启动...${RESET}"

    cat > $SERVICE_FILE <<EOF
[Unit]
Description=R探长抢机脚本
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/rtbot
ExecStart=/bin/bash /root/rtbot/sh_client_bot.sh
StandardOutput=file:/root/rtbot/logs/rtbot.log
StandardError=file:/root/rtbot/logs/rtbot.log
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable rtbot.service
    systemctl start rtbot.service

    echo -e "${GREEN}开机自启动已启用！脚本将在每次开机自动运行，日志路径：/root/rtbot/logs/rtbot.log${RESET}"
    sleep 2
    main_menu
}

# =============================
# 主菜单
# =============================
main_menu() {
    clear
    echo -e "${GREEN}=== 抢机脚本管理菜单 ===${RESET}"
    echo -e "${YELLOW}1) 安装并运行抢机脚本${RESET}"
    echo -e "${YELLOW}2) 卸载抢机脚本（安全一键卸载）${RESET}"
    echo -e "${YELLOW}3) 实时查看抢机日志（按q返回菜单）${RESET}"
    echo -e "${YELLOW}4) 开启抢机开机自启动${RESET}"
    echo -e "${YELLOW}5) 查看抢机脚本状态${RESET}"
    echo -e "${YELLOW}0) 退出${RESET}"
    read -p $'\033[1;91m请选择操作: \033[0m' choice

    case "$choice" in
        1) install_and_run ;;
        2) uninstall_bot ;;
        3) view_logs ;;
        4) enable_autostart ;;
        5) check_status ;;
        0) echo -e "${GREEN}退出脚本${RESET}"; exit 0 ;;
        *) echo -e "${RED}无效选项${RESET}"; sleep 1; main_menu ;;
    esac
}

# =============================
# 脚本入口
# =============================
main_menu
