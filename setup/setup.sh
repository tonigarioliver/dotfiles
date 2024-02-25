#!/bin/bash

# Función para verificar si un paquete está instalado
is_installed() {
    dpkg -s $1 &> /dev/null
}

# Función para instalar un paquete si no está instalado
install_if_not_installed() {
    if ! is_installed $1; then
        sudo apt update
        sudo apt install -y $1
    else
        echo "$1 ya está instalado. Continuando con la siguiente instalación..."
    fi
}
# Instalar Stow si no está instalado
install_if_not_installed stow

# Instalar btop si no está instalado
install_if_not_installed btop

# Instalar gnome-tweaks si no está instalado
install_if_not_installed gnome-tweaks

# Instalar OpenJDK 8
install_if_not_installed openjdk-8-jdk

# Instalar OpenJDK 17
install_if_not_installed openjdk-17-jdk

# Instalar Apache Maven
install_if_not_installed maven

# Instalar Docker Engine según la documentación oficial
if ! is_installed docker-ce; then
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
newgrp docker
    docker run hello-world
else
    echo "Docker ya está instalado. Continuando con la siguiente instalación..."
fi

# Verificar si IntelliJ Community Edition ya está instalado
if ! is_installed intellij-idea-community; then
    sudo apt update
    sudo apt upgrade
    sudo apt install -y snapd
    sudo snap install intellij-idea-community --classic
else
    echo "IntelliJ Community Edition ya está instalado. Continuando con la siguiente instalación..."
fi

# Verificar si VsCode ya está instalado
if ! is_installed code; then
    sudo apt update
    sudo apt upgrade
    sudo snap install code --classic
else
    echo "VsCode ya está instalado. Continuando con la siguiente instalación..."
fi

# Verificar si NodeJs y NVM ya están instalados
if ! is_installed node; then
    sudo apt install -y curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    source ~/.bashrc
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 16.19.0
else
    echo "NodeJs y NVM ya están instalados. Finalizando el script..."
fi
# Instalar Flatpak si no está instalado
install_if_not_installed flatpak

# Agregar el repositorio Flathub si no está agregado
if ! flatpak remote-list | grep -q "flathub"; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo "Repositorio Flathub ya está agregado. Continuando con la siguiente instalación..."
fi

# Download the GPG key and add it to keyrings
wget -O - https://repo.fortinet.com/repo/forticlient/7.2/debian/DEB-GPG-KEY | gpg --dearmor | sudo tee /usr/share/keyrings/repo.fortinet.com.gpg

# Create /etc/apt/sources.list.d/repo.fortinet.com.list
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/repo.fortinet.com.gpg] https://repo.fortinet.com/repo/forticlient/7.2/debian/ stable non-free" | sudo tee /etc/apt/sources.list.d/repo.fortinet.com.list

# Update package lists
sudo apt-get update

# Install FortiClient
if ! is_installed forticlient; then
    sudo apt install forticlient
else
    echo "FortiClient is already installed. Exiting..."
fi

# Instalar GitKraken a través de Flatpak si no está instalado
if ! flatpak list | grep -q "com.axosoft.GitKraken"; then
    flatpak install -y flathub com.axosoft.GitKraken
else
    echo "GitKraken ya está instalado. Finalizando el script..."
fi

# Instalar Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
sudo apt install -f
rm ~/Downloads/google-chrome-stable_current_amd64.deb
echo "Google Chrome se ha instalado correctamente."

# Descomprimir el archivo descargado en /opt
cd ~/Downloads || exit
sudo tar xjf firefox-*.tar.bz2 -C /opt

# Copiar el archivo descomprimido en /opt
sudo cp -rp firefox* /opt

# Eliminar el archivo comprimido
sudo rm -rf firefox*.tar.bz2

# Descomprimir el archivo en /opt
cd /opt || exit
sudo tar xjf firefox*.tar.bz2

# Eliminar el archivo comprimido
sudo rm -rf firefox*.tar.bz2

# Cambiar la propiedad del directorio a $USER
sudo chown -R $USER /opt/firefox

# Crear el archivo .desktop en ~/.local/share/applications
desktop_file=~/.local/share/applications/firefox_dev.desktop
cat <<EOF > "$desktop_file"
[Desktop Entry]
Name=Firefox Developer
GenericName=Firefox Developer Edition
Exec=/opt/firefox/firefox %u
Terminal=false
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser.
StartupWMClass=Firefox Developer Edition
EOF

# Dar permisos de ejecución al archivo .desktop
chmod +x "$desktop_file"

echo "Firefox Developer Edition se ha instalado correctamente."
cd "$HOME"

# Link configuration files using Stow
chmod +x ./config_env.sh
./config_env.sh
