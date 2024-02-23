#!/bin/bash
chmod +x ./setup.sh

# Cambiar al directorio home/dotfiles
dotfiles_dir="$HOME/dotfiles"
cd "$dotfiles_dir" || { echo "Error: No se pudo acceder al directorio ~/dotfiles"; exit 1; }

# Listar directorios disponibles en ~/dotfiles
echo "Directorios disponibles en ~/dotfiles:"
options=(*/)
for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i+1))" "${options[$i]}"
done

# Solicitar al usuario que seleccione un directorio
selected_index=0
while ((selected_index < 1 || selected_index > ${#options[@]})); do
    read -p "Selecciona un directorio (introduce el número correspondiente o 0 para salir): " selected_index
    if ((selected_index == 0)); then
        echo "Saliendo del sistema."
        exit 0
    else
        selected_option="${options[$((selected_index-1))]}"
        echo "Seleccionaste: $selected_option"

        # Cambiar al directorio seleccionado
        cd "$selected_option" || { echo "Error: No se pudo acceder al directorio $selected_option"; exit 1; }

        # Listar archivos en el nuevo entorno y aplicar stow adopt uno por uno
        selected_option=${selected_option%/}
        echo "La ruta actual del terminal es: $PWD"
        for dir in */; do
           dir=${dir%/}
           echo "$dir"
           echo "$HOME"
           echo "Aplicando stow adopt a $dotfiles_dir/$selected_option $dir"...
           stow --adopt -t $HOME $dir
        done

        echo "stow adopt completado en el entorno $selected_option."
    fi
done
# Restaurar cambios en dotfiles con git restore
#git restore "$dotfiles_dir"
