#!/bin/bash

# =============================
# 颜色定义
# =============================
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# =============================
# 菜单函数
# =============================
menu() {
    clear
    echo -e "${GREEN}=== 甲骨文管理菜单 ===${RESET}"
    echo -e "${GREEN}当前时间: $(date '+%Y-%m-%d %H:%M:%S')${RESET}"
    echo -e "${GREEN}1)  甲骨文救砖${RESET}"
    echo -e "${GREEN}2)  开启 ROOT 登录${RESET}"
    echo -e "${GREEN}3)  一键重装系统${RESET}"
    echo -e "${GREEN}4)  恢复 IPv6${RESET}"
    echo -e "${GREEN}5)  安装保活 Oracle${RESET}"
    echo -e "${GREEN}6)  安装 lookbusy 保活${RESET}"
    echo -e "${GREEN}7)  安装 R 探长${RESET}"
    echo -e "${GREEN}8)  安装 Y 探长${RESET}"
    echo -e "${GREEN}9)  安装oci-start${RESET}"
    echo -e "${GREEN}10) 计算圆周率${RESET}"
    echo -e "${GREEN}0)  退出${RESET}"
    echo
    read -p $'\033[32m请选择操作 (0-10): \033[0m' choice

    case $choice in
        1)
            echo -e "${GREEN}正在执行甲骨文救砖...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/ocibrick.sh)
            pause
            ;;
        2)
            echo -e "${GREEN}正在开启 ROOT 登录...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/tool/main/xgroot.sh)
            pause
            ;;
        3)
            echo -e "${GREEN}正在一键重装系统...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/DDoracle.sh)
            pause
            ;;
        4)
            echo -e "${GREEN}正在恢复 IPv6...${RESET}"
            bash <(curl -L -s jhb.ovh/jb/v6.sh)
            pause
            ;;
        5)
            echo -e "${GREEN}正在安装保活 Oracle...${RESET}"
            bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh)
            pause
            ;;
        6)
            echo -e "${GREEN}正在安装 lookbusy 保活...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/lookbusy.sh)
            pause
            ;;
        7)
            echo -e "${GREEN}正在安装 R 探长...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/R-Bot.sh)
            pause
            ;;
        8)
            echo -e "${GREEN}正在运行 Y 探长...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/Yoci-helper.sh)
            pause
            ;;
        9)
            echo -e "${GREEN}正在运行 oci-start...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/oci-start.sh)
            pause
            ;;
        10)
            echo -e "${GREEN}正在计算圆周率...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/toy/main/pai.sh)
            pause
            ;;
        0)
            echo -e "${GREEN}已退出，再见！${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选择，请重新输入${RESET}"
            sleep 1
            ;;
    esac
}

# =============================
# 返回菜单函数
# =============================
pause() {
    read -p $'\033[32m按回车键返回菜单...\033[0m'
}

# =============================
# 主循环
# =============================
while true; do
    menu
done
