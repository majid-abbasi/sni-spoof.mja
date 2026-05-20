#!/bin/bash

set -e

APP_NAME="sni-spoof-mja"
INSTALL_DIR="/etc/${APP_NAME}"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"
MANAGER_FILE="/usr/local/bin/mja"

REPO="https://raw.githubusercontent.com/majid-abbasi/sni-spoof.mja/main"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

banner() {
    clear
    echo -e "${BLUE}"
    echo "================================================="
    echo "            SNI SPOOF MJA INSTALLER"
    echo "================================================="
    echo -e "${NC}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run as root${NC}"
        exit 1
    fi
}

install_packages() {

    echo -e "${YELLOW}Installing requirements...${NC}"

    if command -v apt >/dev/null 2>&1; then

        apt update

        DEBIAN_FRONTEND=noninteractive apt install -y \
        golang-go curl wget nano unzip

    elif command -v dnf >/dev/null 2>&1; then

        dnf install -y golang curl wget nano unzip

    elif command -v yum >/dev/null 2>&1; then

        yum install -y golang curl wget nano unzip

    elif command -v pacman >/dev/null 2>&1; then

        pacman -Sy --noconfirm go curl wget nano unzip

    else

        echo -e "${RED}Unsupported package manager${NC}"
        exit 1

    fi
}

create_user() {

    if id "${APP_NAME}" &>/dev/null; then
        echo "User exists"
    else
        useradd -r -s /usr/sbin/nologin ${APP_NAME}
    fi
}

install_files() {

    mkdir -p ${INSTALL_DIR}

    echo -e "${YELLOW}Downloading files...${NC}"

    curl -L ${REPO}/sni-spoof-mja -o ${INSTALL_DIR}/sni-spoof-mja
    curl -L ${REPO}/config.json -o ${INSTALL_DIR}/config.json

    chmod +x ${INSTALL_DIR}/sni-spoof-mja

    chown -R ${APP_NAME}:${APP_NAME} ${INSTALL_DIR}
}

create_service() {

cat > ${SERVICE_FILE} <<EOF
[Unit]
Description=SNI Spoof MJA Service
After=network.target

[Service]
Type=simple
User=${APP_NAME}
WorkingDirectory=${INSTALL_DIR}
ExecStart=${INSTALL_DIR}/sni-spoof-mja
Restart=always
RestartSec=5
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable ${APP_NAME}
    systemctl restart ${APP_NAME}
}

create_manager() {

cat > ${MANAGER_FILE} << 'EOF'
#!/bin/bash

APP_NAME="sni-spoof-mja"
INSTALL_DIR="/etc/${APP_NAME}"
SERVICE_NAME="${APP_NAME}.service"
BACKUP_DIR="/etc/${APP_NAME}/backup"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

mkdir -p ${BACKUP_DIR}

while true; do

clear

echo -e "${BLUE}"
echo "====================================="
echo "        SNI SPOOF MJA MANAGER"
echo "====================================="
echo -e "${NC}"

echo "1) Edit Config"
echo "2) Restart Program"
echo "3) Service Status"
echo "4) View Logs"
echo "5) Backup Config"
echo "6) Restore Config"
echo "7) Auto Update"
echo "8) Remove Program"
echo "9) Exit"

echo ""
read -p "Select Option: " OPTION

case $OPTION in

1)

    if command -v nano >/dev/null 2>&1; then
        nano ${INSTALL_DIR}/config.json
    else
        vi ${INSTALL_DIR}/config.json
    fi

    ;;

2)

    systemctl restart ${APP_NAME}

    echo -e "${GREEN}Restarted successfully${NC}"

    sleep 2

    ;;

3)

    systemctl status ${APP_NAME} --no-pager

    read -p "Press Enter..."

    ;;

4)

    journalctl -u ${APP_NAME} -n 50 --no-pager

    read -p "Press Enter..."

    ;;

5)

    cp ${INSTALL_DIR}/config.json \
    ${BACKUP_DIR}/config-$(date +%F-%H-%M-%S).json

    echo -e "${GREEN}Backup completed${NC}"

    sleep 2

    ;;

6)

    echo "Available Backups:"
    ls -1 ${BACKUP_DIR}

    echo ""

    read -p "Enter backup filename: " BACKUP_NAME

    if [ -f ${BACKUP_DIR}/${BACKUP_NAME} ]; then

        cp ${BACKUP_DIR}/${BACKUP_NAME} \
        ${INSTALL_DIR}/config.json

        systemctl restart ${APP_NAME}

        echo -e "${GREEN}Restore completed${NC}"

    else

        echo -e "${RED}Backup not found${NC}"

    fi

    sleep 2

    ;;

7)

    curl -L \
    https://raw.githubusercontent.com/majid-abbasi/sni-spoof.mja/main/install.sh \
    -o /tmp/install.sh

    chmod +x /tmp/install.sh

    bash /tmp/install.sh

    exit

    ;;

8)

    read -p "Remove ${APP_NAME}? [y/n]: " CONFIRM

    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then

        systemctl stop ${APP_NAME} || true

        systemctl disable ${APP_NAME} || true

        rm -f /etc/systemd/system/${SERVICE_NAME}

        systemctl daemon-reload

        userdel ${APP_NAME} || true

        rm -rf ${INSTALL_DIR}

        rm -f /usr/local/bin/mja

        echo -e "${GREEN}Removed Successfully${NC}"

        sleep 2

        exit
    fi

    ;;

9)

    exit

    ;;

*)

    echo -e "${RED}Invalid Option${NC}"

    sleep 2

    ;;

esac

done
EOF

chmod +x ${MANAGER_FILE}
}

finish_message() {

    echo ""

    echo -e "${GREEN}=======================================${NC}"
    echo -e "${GREEN} Installation Completed Successfully${NC}"
    echo -e "${GREEN}=======================================${NC}"

    echo ""

    echo -e "${BLUE}Manager Command:${NC} mja"

    echo ""
}

banner
check_root
install_packages
create_user
install_files
create_service
create_manager
finish_message