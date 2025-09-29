#!/bin/bash

# =============================
# 颜色定义
# =============================
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

# =============================
# 脚本路径
# =============================
SCRIPT_PATH="/usr/local/bin/oracle.sh"
SCRIPT_URL="https://raw.githubusercontent.com/Polarisiu/oracle/main/oracle.sh"
BIN_LINK_DIR="/usr/local/bin"

# =============================
# 暂停函数
# =============================
pause() {
    read -p "回车返回菜单..."
}

# =============================
# 菜单函数
# =============================
menu() {
    echo -e "${GREEN}=== 甲骨文管理菜单 ===${RESET}"
    echo -e "${GREEN}[01] 甲骨文救砖${RESET}"
    echo -e "${GREEN}[02] 开启 ROOT 登录${RESET}"
    echo -e "${GREEN}[03] 一键重装系统${RESET}"
    echo -e "${GREEN}[04] 恢复 IPv6${RESET}"
    echo -e "${GREEN}[05] 安装保活 Oracle${RESET}"
    echo -e "${GREEN}[06] 安装 lookbusy 保活${RESET}"
    echo -e "${GREEN}[07] 安装 R 探长${RESET}"
    echo -e "${GREEN}[08] 安装 Y 探长${RESET}"
    echo -e "${GREEN}[09] 安装 oci-start${RESET}"
    echo -e "${GREEN}[10] 计算圆周率${RESET}"
    echo -e "${GREEN}[11] 更新脚本${RESET}"
    echo -e "${GREEN}[12] 卸载脚本${RESET}"
    echo -e "${GREEN}[0 ] 退出${RESET}"
    read -p "请选择: " choice
    case $choice in
        1)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/ocibrick.sh) && pause ;;
        2)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/tool/main/xgroot.sh) && pause ;;
        3)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/DDoracle.sh) && pause ;;
        4)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/ipv6.sh) && pause ;;
        5)  bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh) && pause ;;
        6)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/lookbusy.sh) && pause ;;
        7)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/oracle/main/R-Bot.sh) && pause ;;
        8)  bash <(wget -qO- https://github.com/Yohann0617/oci-helper/releases/latest/download/sh_oci-helper_install.sh) && pause ;;
        9)  bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/app-store/main/oci-start.sh) && pause ;;
        10) bash <(curl -fsSL https://raw.githubusercontent.com/Polarisiu/toy/main/pai.sh) && pause ;;
        11)
            echo -e "${YELLOW}🔄 正在更新脚本...${RESET}"
            curl -fsSL -o "$SCRIPT_PATH" "$SCRIPT_URL"
            chmod +x "$SCRIPT_PATH"
            ln -sf "$SCRIPT_PATH" "$BIN_LINK_DIR/o"
            ln -sf "$SCRIPT_PATH" "$BIN_LINK_DIR/O"
            echo -e "${GREEN}✅ 脚本已更新，可继续使用 o/O 启动${RESET}"
            exec "$SCRIPT_PATH"
            ;;
        12)
            echo -e "${RED}⚠️ 即将卸载脚本${RESET}"
            read -p "确认卸载? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                rm -f "$BIN_LINK_DIR/o" "$BIN_LINK_DIR/O" "$SCRIPT_PATH"
                echo -e "${GREEN}✅ 卸载完成${RESET}"
                exit 0
            fi
            ;;
        0) exit 0 ;;
        *) echo -e "${RED}无效选择，请重新输入${RESET}" && pause ;;
    esac
    menu
}

# =============================
# 首次运行自动安装
# =============================
if [ ! -f "$SCRIPT_PATH" ]; then
    echo -e "${YELLOW}首次运行，正在保存脚本到 $SCRIPT_PATH ...${RESET}"
    curl -fsSL -o "$SCRIPT_PATH" "$SCRIPT_URL"
    chmod +x "$SCRIPT_PATH"
    ln -sf "$SCRIPT_PATH" "$BIN_LINK_DIR/o"
    ln -sf "$SCRIPT_PATH" "$BIN_LINK_DIR/O"
    echo -e "${GREEN}✅ 安装完成${RESET}"
    echo -e "${GREEN}💡 快捷键已添加：o 或 O 可快速启动${RESET}"
fi

menu
