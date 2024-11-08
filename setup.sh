#!/bin/bash

# Define the apps to manage and the GitHub repository URL
apps=("tmux" "nvim" "zoxide" "alacritty" "ohmyposh")
github_repo="https://github.com/mrsujnan/dotfiles.git"
temp_dir="$HOME/temp_dotfiles"

# Colors for pretty output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print a section header
section() {
    echo -e "${CYAN}==> $1${NC}"
}

# Install packages based on detected Linux distribution
install_packages() {
    section "Detecting Linux distribution and installing packages..."
    if [ -f /etc/os-release ]; then
        distro_id=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

        if [[ "$distro_id" == "arch" ]]; then
            echo -e "${GREEN}Arch Linux detected. Installing packages...${NC}"
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm tmux neovim zoxide alacritty
            git clone https://aur.archlinux.org/oh-my-posh-bin.git
            cd oh-my-posh-bin && makepkg -si --noconfirm && cd ..
            rm -rf oh-my-posh-bin

        elif [[ "$distro_id" == "kali" ]]; then
            echo -e "${GREEN}Kali Linux detected. Installing packages...${NC}"
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y tmux zoxide alacritty wget unzip

            # Install latest Neovim
            wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
            tar xzf nvim-linux64.tar.gz
            sudo mv nvim-linux64/bin/nvim /usr/local/bin/
            rm -rf nvim-linux64 nvim-linux64.tar.gz

            # Install oh-my-posh
            wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O oh-my-posh
            sudo install oh-my-posh /usr/local/bin/oh-my-posh
            rm oh-my-posh

        else
            echo -e "${RED}Unknown Linux distribution: $distro_id${NC}"
            exit 1
        fi
    else
        echo -e "${RED}/etc/os-release not found. Cannot determine Linux distribution.${NC}"
        exit 1
    fi
}

# Install necessary packages
install_packages

# Clone GitHub repository
section "Cloning GitHub repository..."
if git clone "$github_repo" "$temp_dir"; then
    echo -e "${GREEN}Repository cloned successfully.${NC}"
else
    echo -e "${RED}Failed to clone repository.${NC}"
    exit 1
fi

# Remove and copy configurations interactively
for app in "${apps[@]}"; do
    read -p "$(echo -e "${YELLOW}Do you want to replace the configuration for $app? (y/n): ${NC}")" response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        config_path="$HOME/.config/$app"
        if [ -d "$config_path" ]; then
            rm -rf "$config_path"
            echo -e "${CYAN}Removed existing configuration for $app.${NC}"
        fi

        repo_config_path="$temp_dir/.config/$app"
        if [ -d "$repo_config_path" ]; then
            mv "$repo_config_path" "$HOME/.config/"
            echo -e "${GREEN}Moved configuration for $app to ~/.config.${NC}"
        else
            echo -e "${RED}No configuration found for $app in the repository.${NC}"
        fi
    else
        echo -e "${CYAN}Skipped configuration for $app.${NC}"
    fi
done

# Ask for confirmation to replace .zshrc
read -p "$(echo -e "${YELLOW}Do you want to replace .zshrc with the one in the repository? (y/n): ${NC}")" response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    if [ -f "$HOME/.zshrc" ]; then
        rm "$HOME/.zshrc"
        echo -e "${CYAN}Removed existing .zshrc file.${NC}"
    fi

    if [ -f "$temp_dir/.zshrc" ]; then
        mv "$temp_dir/.zshrc" "$HOME/"
        echo -e "${GREEN}Moved .zshrc to home directory.${NC}"
    else
        echo -e "${RED}.zshrc file not found in the repository.${NC}"
    fi
else
    echo -e "${CYAN}Skipped .zshrc replacement.${NC}"
fi

# Cleanup temporary directory
rm -rf "$temp_dir"
echo -e "${GREEN}Setup complete.${NC}"
