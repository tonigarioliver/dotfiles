#!/bin/bash

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

