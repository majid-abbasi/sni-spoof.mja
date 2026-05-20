#!/bin/bash

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
    echo "======================================"
    echo "        SNI SPOOF MJA INSTALLER"
    echo "======================================"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Run as root!"
        exit 1
    fi
}

install_packages() {

    if command -v apt >/dev/null 2>&1; then
        apt install -y curl wget nano golang-go
    elif command -v yum >/dev/null 2>&1; then
        yum install -y curl wget nano golang
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y curl wget nano golang
    elif command -v pacman >/dev/null 2>&1; then
        pacman -Sy --noconfirm curl wget nano go
    fi
}

install_files() {

    mkdir -p "$INSTALL_DIR/backup"

    curl -L "$REPO/sni-spoof-mja" -o "$INSTALL_DIR/sni-spoof-mja"
    curl -L "$REPO/config.json" -o "$INSTALL_DIR/config.json"

    chmod +x "$INSTALL_DIR/sni-spoof-mja"
}

create_service() {

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=SNI Spoof MJA Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=/bin/bash -c "cd $INSTALL_DIR && ./sni-spoof-mja"
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable $APP_NAME
    systemctl restart $APP_NAME
}

create_manager() {

cat > "$MANAGER_FILE" <<'EOF'
#!/bin/bash

APP="sni-spoof-mja"
DIR="/etc/sni-spoof-mja"
BACKUP="$DIR/backup"

mkdir -p "$BACKUP"

while true; do
clear

echo "======================"
echo "      MJA MENU"
echo "======================"
echo "1) Edit Config"
echo "2) Restart"
echo "3) Status"
echo "4) Logs"
echo "5) Backup Config"
echo "6) Restore Config"
echo "7) Remove"
echo "8) Exit"
echo ""

read -p "Select: " c

case $c in

1)
nano $DIR/config.json
;;

2)
systemctl restart $APP
;;

3)
systemctl status $APP
;;

4)
journalctl -u $APP -n 50 --no-pager
;;

5)
cp $DIR/config.json $BACKUP/config-$(date +%F-%H-%M-%S).json
echo "Backup done"
;;

6)
ls $BACKUP
echo ""
read -p "File: " f

cp "$BACKUP/$f" "$DIR/config.json" && systemctl restart $APP
;;

7)
systemctl stop $APP
systemctl disable $APP
rm -rf $DIR
rm -f /etc/systemd/system/$APP.service
rm -f /usr/local/bin/mja
systemctl daemon-reload
exit
;;

8)
exit
;;

esac

done
EOF

chmod +x "$MANAGER_FILE"
}

finish() {
    echo "======================================"
    echo " Installed Successfully"
    echo " Run: mja"
    echo "======================================"
}

banner
check_root
install_packages
install_files
create_service
create_manager
finish