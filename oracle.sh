#!/bin/bash

# =============================
# 颜色定义
# =============================
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

# =============================
# 本地脚本路径
# =============================
LOCAL_SCRIPT="$HOME/oracle.sh"

# =============================
# 自动下载本地脚本（如果不存在）
# =============================
if [ ! -f "$LOCAL_SCRIPT" ]; then
    echo -e "${GREEN}📥 下载脚本到本地: $LOCAL_SCRIPT${RESET}"
    curl -sL https://raw.githubusercontent.com/Polarisiu/oracle/main/oracle.sh -o "$LOCAL_SCRIPT"
    chmod +x "$LOCAL_SCRIPT"
fi

# =============================
# 自动添加快捷键 o / O（首次提示）
# =============================
add_alias() {
    local added=false
    if ! grep -q "alias o=" ~/.bashrc; then
        echo "alias o='$LOCAL_SCRIPT'" >> ~/.bashrc
        added=true
    fi
    if ! grep -q "alias O=" ~/.bashrc; then
        echo "alias O='$LOCAL_SCRIPT'" >> ~/.bashrc
        added=true
    fi
    if [ "$added" = true ]; then
        echo -e "${GREEN}✅ 已添加快捷键：o 和 O，可在终端输入 o 或 O 启动脚本,重启终端生效${RESET}"
    fi
}
add_alias

# =============================
# 菜单函数
# =============================
menu() {
    clear
    echo -e "${GREEN}=== 甲骨文管理菜单 ===${RESET}"
    echo -e "${YELLOW}当前时间: $(date '+%Y-%m-%d %H:%M:%S')${RESET}"
    printf "${GREEN}[01] 甲骨文救砖${RESET}\n"
    printf "${GREEN}[02] 开启 ROOT 登录${RESET}\n"
    printf "${GREEN}[03] 一键重装系统${RESET}\n"
    printf "${GREEN}[04] 恢复 IPv6${RESET}\n"
    printf "${GREEN}[05] 安装保活 Oracle${RESET}\n"
    printf "${GREEN}[06] 安装 lookbusy 保活${RESET}\n"
    printf "${GREEN}[07] 安装 R 探长${RESET}\n"
    printf "${GREEN}[08] 安装 Y 探长${RESET}\n"
    printf "${GREEN}[09] 安装 oci-start${RESET}\n"
    printf "${GREEN}[10] 计算圆周率${RESET}\n"
    printf "${GREEN}[11] 更新菜单脚本${RESET}\n"
    printf "${GREEN}[12] 卸载菜单脚本${RESET}\n"
    printf "${GREEN}[0 ] 退出${RESET}\n"
    echo
    read -p $'\033[32m请选择操作 (0-12): \033[0m' choice

    case $choice in
        1)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/ocibrick.sh)
            pause
            ;;
        2)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/tool/main/xgroot.sh)
            pause
            ;;
        3)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/DDoracle.sh)
            pause
            ;;
        4)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/ipv6.sh)
            pause
            ;;
        5)
            bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh)
            pause
            ;;
        6)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/lookbusy.sh)
            pause
            ;;
        7)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/R-Bot.sh)
            pause
            ;;
        8)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/Yoci-helper.sh)
            pause
            ;;
        9)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/oci-start.sh)
            pause
            ;;
        10)
            bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/toy/main/pai.sh)
            pause
            ;;
        11)
            echo -e "${GREEN}🔄 更新菜单脚本...${RESET}"
            curl -sL https://raw.githubusercontent.com/Polarisiu/oracle/main/oracle.sh -o "$LOCAL_SCRIPT"
            chmod +x "$LOCAL_SCRIPT"
            echo -e "${GREEN}✅ 已更新本地脚本${RESET}"
            exec "$LOCAL_SCRIPT"
            ;;
        12)
            echo -e "${RED}⚠️ 即将卸载脚本及快捷键 o/O${RESET}"
            read -p "确认卸载？(y/N): " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                sed -i '/alias o=/d' ~/.bashrc
                sed -i '/alias O=/d' ~/.bashrc
                rm -f "$LOCAL_SCRIPT"
                echo -e "${GREEN}✅ 脚本已卸载，快捷键已删除${RESET}"
                exit 0
            else
                echo -e "${YELLOW}取消卸载${RESET}"
                pause
            fi
            ;;
        0)
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
