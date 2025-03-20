#!/bin/bash

    echo -e "\nInstalling Telegram..."
    echo -e "----------------------------------------------------------\n"

    if ! command -v telegram-desktop &> /dev/null; then
        wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
        tar -xf telegram.tar.xz
        sudo mv Telegram /opt/telegram
        sudo ln -s /opt/telegram/Telegram /usr/bin/telegram-desktop
        sudo ln -s /opt/telegram/Updater /usr/bin/telegram-updater
        rm telegram.tar.xz
    else
        echo "Telegram is already installed."
    fi

    echo -e "\n----------------------------------------------------------\n"