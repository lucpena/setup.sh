#!/bin/bash

# To make this script executable, run: chmod +x install.sh

# Remember to download the icons and fonts folder from OneDrive

add_apt_repos() {

    #OneDriver
    echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_23.10/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
    curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_23.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null

    # Update package lists after new repositories are added
    sudo apt update
}

install_apt_packages() {
    echo -e "\nInstalling APT packages..."
    echo -e "----------------------------------------------------------\n"

    # Steam Devices is a package that allows you to use the Steam Controller and other devices on Linux
    # Cool Retro Term is a terminal emulator that mimics the look of old cathode screens
    # Python3 and Python3-pip are the Python packages
    # Ghostscript is a package that interprets PostScript and PDF page description languages
    sudo apt install -y cool-retro-term git steam-devices python3 python3-pip ghostscript

    # Requirements for Anki
    sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3 zstd

    # Sensors
    sudo apt install -y lm-sensors

    # Microsoft fonts and a a lot of stuff that I don't know what it is
    sudo apt install -y ubuntu-restricted-extras

    # OneDriver
    sudo apt install -y onedriver

    # FCITX for Japanese input. This is what Linux Mint installs by default
    sudo apt install -y \
    fcitx-mozc fonts-ipafont-mincho fonts-takao-gothic fonts-takao-mincho ibus-mozc \
    mozc-data mozc-server mozc-utils-gui fcitx fcitx-config-gtk \
    fcitx-frontend-all fcitx-frontend-fbterm fcitx-frontend-gtk2 \
    fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-libs \
    fcitx-module-dbus fcitx-module-kimpanel fcitx-module-lua \
    fcitx-module-x11 fcitx-modules fcitx-tools fcitx-ui-classic \
    gir1.2-fcitx-1.0 ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-table

    # Add FCITX to startup
    echo -e "\nAdding Fcitx to startup..."
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/fcitx.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=fcitx
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Fcitx
Comment=Start Fcitx input method framework
EOL
    echo "Fcitx added to startup."

    # Add Japanese input to the system
    echo -e "\nAdding Japanese input to the system..." 
    im-config -n fcitx
    echo "Japanese input added to the system."

    # MANGOHUD UI
    apt install -y goverlay

    # Dev stuff
    # raylib
    sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev

    echo -e "\n----------------------------------------------------------\n"
}

install_flatpak_packages() {
    echo -e "\nInstalling Flatpak packages..."
    echo -e "----------------------------------------------------------\n"

    flatpak install -y flathub \
        md.obsidian.Obsidian \
        com.bitwarden.desktop \
        org.videolan.VLC \
        com.usebottles.bottles \
        com.valvesoftware.Steam \
        com.github.tchx84.Flatseal

    # Grant access permissions to Flatpak packages
    

    # Remove ugly ass cursor
    flatpak --user override --filesystem=/home/$USER/.icons/:ro
    flatpak --user override --filesystem=/usr/share/icons/:ro

    echo -e "\n----------------------------------------------------------\n"
}

install_curl_packages() {
    echo -e "\nInstalling packages via curl..."
    echo -e "----------------------------------------------------------\n"

    echo -e "\nInstalling Brave browser...\n"
    if ! command -v brave-browser &> /dev/null; then
        curl -fsS https://dl.brave.com/install.sh | sh 
    else
        echo "Brave browser is already installed."
    fi

    echo -e "\nInstalling Ollama...\n"
    if ! command -v ollama &> /dev/null; then
        curl -fsSL https://ollama.com/install.sh | sh
    else
        echo "Ollama is already installed."
    fi

    echo -e "\n----------------------------------------------------------\n"

}

install_telegram() {
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
}

install_vscode() {
    echo -e "\nInstalling VS Code..."
    echo -e "----------------------------------------------------------\n"

    if ! command -v code &> /dev/null; then
        wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
        sudo dpkg -i vscode.deb
        sudo apt-get install -f
        rm vscode.deb
    else
        echo "VS Code is already installed."
    fi

    echo -e "\n----------------------------------------------------------\n"
}

configure_cedilla() {
    echo -e "\nConfiguring Cedilla...\n"
    echo -e "\n----------------------------------------------------------\n"

    if grep -q "GTK_IM_MODULE=cedilla" /etc/environment && grep -q "QT_IM_MODULE=cedilla" /etc/environment; then
        echo "Cedilla is already configured."
    else
        # Edit configuration files
        sudo sed -i 's/\("cedilla" "Cedilla" "gtk30" "\/usr\/share\/locale" "\)/\1en:/' /usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules.cache
        sudo sed -i 's/\("cedilla" "Cedilla" "gtk20" "\/usr\/share\/locale" "\)/\1en:/' /usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules.cache

        # Change the Compose file
        sudo sed -i /usr/share/X11/locale/en_US.UTF-8/Compose -e 's/ć/ç/g' -e 's/Ć/Ç/g'

        # Instruct the system to load the cedilla module
        echo "GTK_IM_MODULE=cedilla" | sudo tee -a /etc/environment
        echo "QT_IM_MODULE=cedilla" | sudo tee -a /etc/environment
    fi

    echo -e "\n----------------------------------------------------------\n"
}

# Not working
update_bashrc() {
    echo -e "\nUpdating .bashrc...\n"
    echo -e "\n----------------------------------------------------------\n"

    echo -e "\necho -e \"\\n\"\nexport PS1=\"\\n [\\w] \\n > \"" >> ~/.bashrc
    echo -e "\n----------------------------------------------------------\n"
}

# Adiciona "Abrir no VS Code" ao menu de contexto do Nemo
create_nemo_action() {
    echo -e "\nCreating Nemo action for VS Code...\n"
    echo -e "\n----------------------------------------------------------\n"

    # Diretório onde as ações do Nemo são armazenadas
    actions_dir="$HOME/.local/share/nemo/actions"

    # Arquivo da ação personalizada
    action_file="$actions_dir/open_with_vscode.nemo_action"

    # Certifique-se de que o diretório de ações do Nemo existe
    mkdir -p "$actions_dir"

    # Criar o arquivo da ação com verificação de sucesso
    if cat > "$action_file" <<EOL
[Nemo Action]
Name=Abrir no VS Code
Comment=Abrir esta pasta no Visual Studio Code
Exec=code "%F"
Icon=/usr/share/code/resources/app/resources/linux/code.png
Selection=Any
Extensions=dir;
EOL
    then
        echo "Arquivo da action criado com sucesso!"
    else
        echo "Erro ao criar o arquivo da action!" >&2
        exit 1
    fi

    # Verifica se o arquivo foi realmente criado
    if [ -f "$action_file" ]; then
        echo "Arquivo '$action_file' verificado com sucesso."
    else
        echo "Erro: O arquivo '$action_file' não foi encontrado!" >&2
        exit 1
    fi

    # Reiniciar o Nemo para aplicar as mudanças
    if nemo -q; then
        echo "Nemo reiniciado com sucesso!"
    else
        echo "Erro ao reiniciar o Nemo. Você pode tentar fechar e abrir manualmente." >&2
    fi

    echo "Ação 'Abrir no VS Code' adicionada ao menu de contexto do Nemo!"
    echo -e "\n----------------------------------------------------------\n"
}

install_github() {
    echo -e "\nInstalling GitHub CLI..."
    echo -e "----------------------------------------------------------\n"

    if ! command -v gh &> /dev/null; then
        (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y
    else
        echo "GitHub CLI is already installed."
    fi

    echo -e "\n----------------------------------------------------------\n"
}

install_anki() {

    echo -e "\nInstalling Anki..."
    echo -e "----------------------------------------------------------\n"

    if ! command -v anki &> /dev/null; then
        # Download Anki (replace the URL with the latest version if necessary)
        wget -P "$(dirname "$0")"/Downloads https://github.com/ankitects/anki/releases/download/25.02/anki-25.02-linux-qt6.tar.zst

        # Extract the downloaded tar file
        tar xaf "$(dirname "$0")"/Downloads/anki-25.02-linux-qt6.tar.zst -C "$(dirname "$0")"/Downloads

        # Change directory to the extracted folder
        cd "$(dirname "$0")"/Downloads/anki-25.02-linux-qt6

        # Run the install script
        sudo ./install.sh

        # Print message to start Anki
        echo "You can now start Anki by typing 'anki' and hitting enter."
    else
        echo "Anki is already installed."
    fi  

    echo -e "\n----------------------------------------------------------\n"

}

install_fonts() {
    echo -e "\nInstalling fonts..."
    echo -e "----------------------------------------------------------\n"

   # Directory containing fonts
    FONT_DIR="./fonts"

    # System-wide fonts directory
    SYSTEM_FONT_DIR="/usr/local/share/fonts"

    # Check if the fonts directory exists
    if [ -d "$FONT_DIR" ]; then
        # Loop through each font file in the directory
        for font in "$FONT_DIR"/*; do
            # Get the base name of the font file
            font_name=$(basename "$font")
            
            # Check if the font already exists in the system-wide directory
            if [ -f "$SYSTEM_FONT_DIR/$font_name" ]; then
                echo "Font $font_name already exists, skipping..."
            else
                # Copy the font to the system-wide fonts directory
                sudo cp "$font" "$SYSTEM_FONT_DIR"
                echo "Font $font_name installed."
            fi
        done
        
        # Refresh the font cache
        sudo fc-cache -fv

        # Open the system-wide fonts directory
        xdg-open "$SYSTEM_FONT_DIR"
        
        echo "Fonts installed system-wide and cache refreshed."
    else
        echo "Fonts directory not found."
    fi

    echo -e "\n----------------------------------------------------------\n"
}

install_icons_and_cursor() {
    echo -e "\nInstalling icons and cursors..."
    echo -e "----------------------------------------------------------\n"

    # Directory containing icons and cursors
    ICONS_DIR="./icons"

    # System-wide icons directory
    SYSTEM_ICONS_DIR="/usr/share/icons"

    # Check if the icons directory exists
    if [ -d "$ICONS_DIR" ]; then
        # Copy all contents of the icons directory to the system-wide icons directory
        sudo cp -r "$ICONS_DIR"/* "$SYSTEM_ICONS_DIR"
        echo "Icons and cursors installed."

        # Refresh the icon cache
        sudo gtk-update-icon-cache -f "$SYSTEM_ICONS_DIR"
    else
        echo "Icons directory not found."
    fi

    echo -e "\n----------------------------------------------------------\n"
}

main() {

    echo -e "\nInstalling and configuring random bullshit...\n"

    read -p "This script will install and configure various packages and settings. Do you want to proceed? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Installation aborted."
        exit 0
    fi

    # Create Downloads folder if it does not exist
    mkdir -p "$(dirname "$0")"/Downloads

    # First Update
    echo -e "\nUpdating the system...\n"
    sudo apt update
    sudo apt upgrade -y

    add_apt_repos
    install_apt_packages
    install_flatpak_packages
    install_curl_packages
    install_telegram
    install_vscode
    install_github
    install_anki
    install_fonts
    install_icons_and_cursor

    configure_cedilla
    # Check if nemo is installed
    if command -v nemo &> /dev/null; then
        create_nemo_action
    else
        echo "\t --Nemo is not installed. Skipping Nemo action creation..."
    fi

    # update_bashrc

    # Sensors detection
    sudo sensors-detect --auto

    echo -e "\n----------------------------------------------------------\n"
    echo -e "\nAll done! Now, remeber to:\n"
    echo -e "\t1. Configure your GitHub account by running 'gh auth login'."
    echo -e "\t2. OneDriver: onedriver-launcher, search OneDriver on the menu or onedriver /path/to/mount/onedrive/at/."
    echo -e "\t3. Configure your Japanese input by running 'fcitx-config-gtk3' or Fcitx Configuration."

    echo -e "\t> Reboot your system to apply the changes. lol \n\n"
}

main

# To add
