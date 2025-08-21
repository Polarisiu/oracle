#!/bin/bash
set -euo pipefail
# ========================================
# OCI Docker 管理脚本 (固定端口9856)
# ========================================

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"

APP_PORT=9856
CONTAINER_NAME="oci-start"
SCRIPT_URL="https://raw.githubusercontent.com/doubleDimple/shell-tools/master/docker.sh"
SCRIPT_FILE="docker.sh"

# 创建目录并进入
DIR="$HOME/oci-start-docker"
mkdir -p "$DIR"
cd "$DIR" || exit

# 下载 docker.sh，如果不存在或更新
download_script() {
    echo -e "${CYAN}检查 docker.sh 脚本...${RESET}"
    if [[ ! -f "$SCRIPT_FILE" ]]; then
        wget -O "$SCRIPT_FILE" "$SCRIPT_URL"
        chmod +x "$SCRIPT_FILE"
        echo -e "${GREEN}docker.sh 下载完成${RESET}"
    else
        wget -O "$SCRIPT_FILE.tmp" "$SCRIPT_URL"
        if ! cmp -s "$SCRIPT_FILE" "$SCRIPT_FILE.tmp"; then
            mv "$SCRIPT_FILE.tmp" "$SCRIPT_FILE"
            chmod +x "$SCRIPT_FILE"
            echo -e "${GREEN}docker.sh 已更新${RESET}"
        else
            rm -f "$SCRIPT_FILE.tmp"
            echo -e "${CYAN}docker.sh 已是最新版本${RESET}"
        fi
    fi
}

# 获取服务器公网 IP 或本地 IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}' || echo "localhost")

# 检查端口占用
check_port() {
    if lsof -i:"$APP_PORT" >/dev/null 2>&1; then
        echo -e "${RED}端口 $APP_PORT 已被占用${RESET}"
        read -rp "是否强制释放端口? (y/n): " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            PID=$(lsof -t -i:"$APP_PORT")
            kill -9 "$PID"
            echo -e "${GREEN}端口已释放${RESET}"
        else
            exit 1
        fi
    fi
}

# 菜单
while true; do
    echo -e "\n${GREEN}==== oci-start 管理 ====${RESET}"
    echo -e "${GREEN}1) 安装应用${RESET}"
    echo -e "${GREEN}2) 卸载应用及数据${RESET}"
    echo -e "${GREEN}3) 更新容器${RESET}"
    echo -e "${GREEN}4) 查看访问地址${RESET}"
    echo -e "${GREEN}5) 查看容器日志${RESET}"
    echo -e "${GREEN}6) 退出${RESET}"
    read -rp "请选择操作 [1-6]: " choice

    case $choice in
        1)
            check_port
            download_script
            echo -e "${GREEN}正在安装应用...${RESET}"
            ./"$SCRIPT_FILE" install
            echo -e "${CYAN}访问地址: ${GREEN}http://$SERVER_IP:$APP_PORT${RESET}"
            ;;
        2)
            echo -e "${RED}正在卸载应用及数据...${RESET}"
            if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
                docker stop "$CONTAINER_NAME"
                docker rm -v "$CONTAINER_NAME"
                echo -e "${GREEN}容器及数据已删除${RESET}"
            else
                echo -e "${YELLOW}未找到容器，可能已删除${RESET}"
            fi
            if [[ -d "$DIR" ]]; then
                rm -rf "$DIR"
                echo -e "${GREEN}目录 $DIR 及脚本已彻底删除${RESET}"
            else
                echo -e "${YELLOW}目录 $DIR 不存在，已清理完毕${RESET}"
            fi
            ;;
        3)
            echo -e "${CYAN}正在更新容器...${RESET}"
            if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
                docker stop "$CONTAINER_NAME"
                docker rm "$CONTAINER_NAME"
            fi
            download_script
            ./"$SCRIPT_FILE" install
            echo -e "${CYAN}访问地址: ${GREEN}http://$SERVER_IP:$APP_PORT${RESET}"
            echo -e "${GREEN}容器更新完成并已启动${RESET}"
            ;;
        4)
            echo -e "${CYAN}访问地址: ${GREEN}http://$SERVER_IP:$APP_PORT${RESET}"
            ;;
        5)
            echo -e "${YELLOW}容器日志 (${CONTAINER_NAME}):${RESET}"
            read -rp "是否实时跟随日志? (y/n): " follow
            if [[ "$follow" =~ ^[Yy]$ ]]; then
                docker logs -f "$CONTAINER_NAME"
            else
                docker logs "$CONTAINER_NAME"
            fi
            ;;
        6)
            echo "退出脚本"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选项，请重新选择${RESET}"
            ;;
    esac
done
