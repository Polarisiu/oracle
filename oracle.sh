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
    echo -e "${GREEN}01) 甲骨文救砖${RESET}"
    echo -e "${GREEN}02) 开启 ROOT 登录${RESET}"
    echo -e "${GREEN}03) 一键重装系统${RESET}"
    echo -e "${GREEN}04) 恢复 IPv6${RESET}"
    echo -e "${GREEN}05) 安装保活 Oracle${RESET}"
    echo -e "${GREEN}06) 安装 lookbusy 保活${RESET}"
    echo -e "${GREEN}07) 安装 R 探针${RESET}"
    echo -e "${GREEN}08) y 探长${RESET}"
    echo -e "${GREEN}09) OCI 抢机${RESET}"
    echo -e "${GREEN}10) 计算圆周率${RESET}"
    echo -e "${GREEN} 0) 退出${RESET}"
    echo
    read -p $'\033[32m请选择操作 (0-10): \033[0m' choice

    case $choice in
        01)
            echo -e "${GREEN}正在执行甲骨文救砖...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/iu683/unblock/main/ocijz.sh)
            pause
            ;;
        02)
            echo -e "${GREEN}正在开启 ROOT 登录...${RESET}"
            bash <(curl -sL https://raw.githubusercontent.com/iu683/unblock/main/xgmim.sh)
            pause
            ;;
        03)
            echo -e "${GREEN}正在一键重装系统...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/iu683/unblock/main/ddoci.sh)
            pause
            ;;
        04)
            echo -e "${GREEN}正在恢复 IPv6...${RESET}"
            bash <(curl -L -s jhb.ovh/jb/v6.sh)
            pause
            ;;
        05)
            echo -e "${GREEN}正在安装保活 Oracle...${RESET}"
            bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh)
            pause
            ;;
        06)
            echo -e "${GREEN}正在安装 lookbusy 保活...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/iu683/unblock/main/lookbusy.sh)
            pause
            ;;
        07)
            echo -e "${GREEN}正在安装 R 探针...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/iu683/unblock/main/roci.sh)
            pause
            ;;
        08)
            echo -e "${GREEN}正在运行 y 探长...${RESET}"
            bash <(curl -sL https://raw.githubusercontent.com/iu683/vps-tools/main/oci-helper_install.sh)
            pause
            ;;
        09)
            echo -e "${GREEN}正在运行 OCI 抢机...${RESET}"
            bash <(curl -sL https://raw.githubusercontent.com/iu683/vps-tools/main/oci-docker.sh)
            pause
            ;;
        10)
            echo -e "${GREEN}正在计算圆周率...${RESET}"
            bash <(curl -fsSL https://raw.githubusercontent.com/iu683/unblock/main/jsyzl.sh)
            pause
            ;;
        0)
            exit 0
            ;;
        *)
            echo -e "${RED}无效选择，请重新输入${RESET}"
            sleep 1
            menu
            ;;
    esac
}

# =============================
# 返回菜单函数
# =============================
pause() {
    read -p $'\033[32m按回车键返回菜单...\033[0m'
    menu
}

# =============================
# 启动菜单
# =============================
menu
