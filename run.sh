#!/bin/bash

# Función para inicializar un repositorio Git y hacer un commit
initialize_git() {
    echo "Iniciando repositorio Git..."
    git init
    git add .
    git commit -m "Initial commit"
    echo "Repositorio Git iniciado y cambios commitados."
}

# Preguntar al usuario si es una instalación limpia
read -p "¿It's a clean isntall? (Y/n): " clean_install
if [[ $clean_install =~ ^[Yy]$ ]]; then
    initialize_git
fi

# Cambiar al directorio del script
cd "$HOME/dotfiles/setup"

# Asignar permisos ejecutables al script
chmod +x "./setup.sh"

# Mensaje de inicio con ASCII art
echo "
 ██████╗ ███████╗███╗   ██╗███╗   ██╗███████╗███╗   ███╗███████╗███╗   ██╗
██╔════╝ ██╔════╝████╗  ██║████╗  ██║██╔════╝████╗ ████║██╔════╝████╗  ██║
██║  ███╗█████╗  ██╔██╗ ██║██╔██╗ ██║█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║
██║   ██║██╔══╝  ██║╚██╗██║██║╚██╗██║██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║
╚██████╔╝███████╗██║ ╚████║██║ ╚████║███████╗██║ ╚═╝ ██║███████╗██║ ╚████║
 ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝
"

# Ejecutar el script
./setup.sh

# Mensaje de finalización
echo "FALCON installation completed successfully!"
echo "Rebooting system
sudo reboot

