# Function to create a backup
create_backup() {
    read -p "Do you want to create a backup in $HOME? (Y/n): " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        backup_dir="$HOME/dotfiles_backup/"
        if [ ! -d "$backup_dir" ]; then
            mkdir -p "$backup_dir"
        fi
        echo "Creating backup in $backup_dir..."
        cp -r "$dotfiles_dir/$selected_option" "$backup_dir"
        echo "Backup created in $backup_dir."
    else
        echo "No backup created."
    fi
}
# Function to create a backup
apply_restore() {
    read -p "Do you want to restore of original source symlink files? (Y/n): " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
	git restore "$dotfiles_dir"
    else
        echo "No Restore executed."
    fi
}

# Change to the home/dotfiles directory
dotfiles_dir="$HOME/dotfiles"
cd "$dotfiles_dir" || { echo "Error: Couldn't access the ~/dotfiles directory"; exit 1; }

# List available directories in ~/dotfiles excluding "setup"
echo "Directories available in ~/dotfiles (excluding 'setup'):"
options=()
for dir in */; do
    if [[ "$dir" != "setup/" ]]; then
        options+=("$dir")
    fi
done

# Show available options to the user
for i in "${!options[@]}"; do
    printf "%d) %s\n" "$((i+1))" "${options[$i]}"
done

# Prompt the user to select a directory
selected_index=0
while ((selected_index < 1 || selected_index > ${#options[@]})); do
    read -p "Select a directory (enter the corresponding number or 0 to exit): " selected_index
    if ((selected_index == 0)); then
        echo "Exiting the system."
        exit 0
    else
        selected_option="${options[$((selected_index-1))]}"
        echo "You selected: $selected_option"

        # Change to the selected directory
        cd "$selected_option" || { echo "Error: Couldn't access the $selected_option directory"; exit 1; }
	echo "hello"
        # List files in the new environment and apply stow adopt one by one
        selected_option=${selected_option%/}
        echo "Current terminal path is: $PWD"
        for dir in */; do
            dir=${dir%/}
            echo "Applying stow adopt to $dotfiles_dir/$selected_option $dir"...
            stow --adopt -t "$HOME" "$dir"
        done

        echo "stow adopt completed in the $selected_option environment."
	echo "bye"
        # Ask the user if they want to create a backup
        create_backup
        # Ask the user if they want to restore
        apply_restore
    fi
done


