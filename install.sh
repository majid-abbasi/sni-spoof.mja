#!/bin/bash
5)
    cp ${INSTALL_DIR}/config.json ${BACKUP_DIR}/config-$(date +%F-%H-%M-%S).json
    echo -e "${GREEN}Backup completed${NC}"
    sleep 2
    ;;

6)
    echo "Available Backups:"
    ls -1 ${BACKUP_DIR}
    echo ""
    read -p "Enter backup filename: " BACKUP_NAME

    if [ -f ${BACKUP_DIR}/${BACKUP_NAME} ]; then
        cp ${BACKUP_DIR}/${BACKUP_NAME} ${INSTALL_DIR}/config.json
        systemctl restart ${APP_NAME}
        echo -e "${GREEN}Restore completed${NC}"
    else
        echo -e "${RED}Backup not found${NC}"
    fi

    sleep 2
    ;;

7)
    curl -L https://raw.githubusercontent.com/majid-abbasi/sni-spoof-mja/main/install.sh -o /tmp/install.sh
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