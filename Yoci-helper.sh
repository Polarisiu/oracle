#!/bin/bash
# ========================================
# oci-helper 菜单式管理脚本
# ========================================

# 颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

CONFIG_FILE="/app/oci-helper/application.yml"
INSTALL_URL="https://github.com/Yohann0617/oci-helper/releases/latest/download/sh_oci-helper_install.sh"
CONTAINER_NAME="oci-helper"
PORT=8818  # oci-helper 访问端口

# 获取本机 IP
get_ip() {
    IP=$(hostname -I 2>/dev/null | awk '{print $1}')
    [ -z "$IP" ] && IP="127.0.0.1"
    echo "$IP"
}

# 显示访问地址
show_access() {
    IP=$(get_ip)
    echo -e "${GREEN}访问地址: http://$IP:$PORT${RESET}"
}

# 安装 oci-helper
install_oci() {
    echo -e "${GREEN}正在安装 oci-helper...${RESET}"
    bash <(wget -qO- "$INSTALL_URL") || echo -e "${RED}安装失败，请检查网络或 URL${RESET}"
    echo -e "${GREEN}安装完成！${RESET}"
    show_access
}

# 修改配置
edit_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}配置文件不存在: $CONFIG_FILE${RESET}"
        echo -e "${YELLOW}请先安装 oci-helper 再修改配置${RESET}"
        return
    fi
    nano "$CONFIG_FILE"
    echo -e "${GREEN}配置已修改，正在重启容器...${RESET}"
    restart_container
}

# 重启容器
restart_container() {
    if docker ps -a --format '{{.Names}}' | grep -qw "$CONTAINER_NAME"; then
        docker restart "$CONTAINER_NAME"
        echo -e "${GREEN}容器已重启${RESET}"
        show_access
    else
        echo -e "${RED}容器不存在，请先安装${RESET}"
    fi
}

# 卸载 oci-helper（安全版）
uninstall_oci() {
    # 删除容器
    if docker ps -a --format '{{.Names}}' | grep -qw "$CONTAINER_NAME"; then
        echo -e "${YELLOW}正在停止并删除容器...${RESET}"
        docker stop "$CONTAINER_NAME" >/dev/null 2>&1
        docker rm "$CONTAINER_NAME" >/dev/null 2>&1
    else
        echo -e "${YELLOW}容器不存在，无需停止或删除${RESET}"
    fi

    # 删除镜像
    IMAGE_ID=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep oci-helper)
    if [ -n "$IMAGE_ID" ]; then
        echo -e "${YELLOW}正在删除镜像...${RESET}"
        docker rmi "$IMAGE_ID" >/dev/null 2>&1
    else
        echo -e "${YELLOW}镜像不存在，无需删除${RESET}"
    fi

    echo -e "${GREEN}卸载完成${RESET}"
}

# 更新 oci-helper
update_oci() {
    echo -e "${GREEN}正在更新 oci-helper 到最新版本...${RESET}"
    docker stop "$CONTAINER_NAME" >/dev/null 2>&1
    docker rm "$CONTAINER_NAME" >/dev/null 2>&1
    bash <(wget -qO- "$INSTALL_URL") || echo -e "${RED}更新失败，请检查网络或 URL${RESET}"
    echo -e "${GREEN}更新完成！${RESET}"
    show_access
}

# 查看日志
view_logs() {
    echo -e "${GREEN}按 Ctrl+C 停止查看日志${RESET}"
    docker logs -f --tail 100 "$CONTAINER_NAME"
}

# 菜单
menu() {
    clear
    echo -e "${GREEN}====== oci-helper 菜单式管理 ======${RESET}"
    echo -e "${GREEN}1. 安装${RESET}"
    echo -e "${GREEN}2. 修改配置文件${RESET}"
    echo -e "${GREEN}3. 重启容器${RESET}"
    echo -e "${GREEN}4. 卸载${RESET}"
    echo -e "${GREEN}5. 更新${RESET}"
    echo -e "${GREEN}6. 查看运行日志${RESET}"
    echo -e "${GREEN}0. 退出${RESET}"
    echo -ne "${YELLOW}请选择: ${RESET}"
    read -r choice

    case $choice in
        1) install_oci ;;
        2) edit_config ;;
        3) restart_container ;;
        4) uninstall_oci ;;
        5) update_oci ;;
        6) view_logs ;;
        0) exit 0 ;;
        *) echo -e "${RED}无效选择${RESET}" ;;
    esac

    echo -e "${YELLOW}按任意键返回菜单...${RESET}"
    read -n 1 -s
    echo
    menu
}

# 主程序
menu
