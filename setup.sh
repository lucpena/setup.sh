# To make this script executable, run: chmod +x install.sh

#!/bin/bash

install_apt_packages() {
    echo -e "\nInstalling APT packages...\n"
    echo -e "\n----------------------------------------------------------\n"

    # Steam Devices is a package that allows you to use the Steam Controller and other devices on Linux
    # Cool Retro Term is a terminal emulator that mimics the look of old cathode screens
    # Python3 and Python3-pip are the Python packages

    sudo apt update
    sudo apt install -y cool-retro-term git steam-devices python3 python3-pip 

    echo -e "\n----------------------------------------------------------\n"
}

install_flatpak_packages() {
    echo -e "\nInstalling Flatpak packages...\n"
    echo -e "\n----------------------------------------------------------\n"

    flatpak install flathub \
        org.telegram.desktop \
        md.obsidian.Obsidian \
        com.bitwarden.desktop \
        org.videolan.VLC \
        com.usebottles.bottles \
        com.valvesoftware.Steam -y

    echo -e "\n----------------------------------------------------------\n"
}

install_curl_packages() {
    echo -e "\nInstalling packages via curl...\n"
    echo -e "\n----------------------------------------------------------\n"

    curl -fsS https://dl.brave.com/install.sh | sh 
    curl -fsSL https://ollama.com/install.sh | sh

    echo -e "\n----------------------------------------------------------\n"

}

install_vscode() {
    echo -e "\nInstalling VS Code...\n"
    echo -e "\n----------------------------------------------------------\n"

    wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg -i vscode.deb
    sudo apt-get install -f
    rm vscode.deb

    echo -e "\n----------------------------------------------------------\n"
}

configure_cedilla() {
    echo -e "\nConfiguring Cedilla...\n"
    echo -e "\n----------------------------------------------------------\n"

    # Edit configuration files
    sudo sed -i 's/\("cedilla" "Cedilla" "gtk30" "\/usr\/share\/locale" "\)/\1en:/' /usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules.cache
    sudo sed -i 's/\("cedilla" "Cedilla" "gtk20" "\/usr\/share\/locale" "\)/\1en:/' /usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules.cache

    # Change the Compose file
    sudo sed -i /usr/share/X11/locale/en_US.UTF-8/Compose -e 's/ć/ç/g' -e 's/Ć/Ç/g'

    # Instruct the system to load the cedilla module
    echo "GTK_IM_MODULE=cedilla" | sudo tee -a /etc/environment
    echo "QT_IM_MODULE=cedilla" | sudo tee -a /etc/environment

    echo -e "\n----------------------------------------------------------\n"
}

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

main() {

    echo -e "\nInstalling and configuring random bullshit...\n"

    install_apt_packages
    install_flatpak_packages
    install_curl_packages
    install_vscode
    configure_cedilla
    update_bashrc
    create_nemo_action

    echo -e "\n\n\t > Reboot your system to apply the changes. lol \n\n"
}

main

# To add