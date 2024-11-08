#!/bin/bash

# Setup script for configuring various apps

# Function to check Linux distro
check_distro() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DISTRO=$ID
    else
        echo "Unknown Linux distribution. Exiting."
        exit 1
    fi
}

# Check the distro and install the necessary packages
install_packages() {
    case $DISTRO in
        arch)
            echo "Installing packages for Arch Linux..."
            sudo pacman -Syu --noconfirm tmux nvim zoxide alacritty oh-my-posh
            ;;
        kali)
            echo "Installing packages for Kali Linux..."
            sudo apt update && sudo apt install -y tmux neovim zoxide alacritty oh-my-posh
            ;;
        *)
            echo "Unsupported distro: $DISTRO. Exiting."
            exit 1
            ;;
    esac
}

# Setup tmux
setup_tmux() {
    echo "Setting up tmux..."
    cp .tmux.conf ~/.tmux.conf
    # Installing tmux plugin manager
    if [ ! -d "~/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    # Install tmux plugins
    echo "Press prefix + I to install plugins"
}

# Setup neovim
setup_nvim() {
    echo "Setting up Neovim..."
    mkdir -p ~/.config/nvim
    cp -r nvim/* ~/.config/nvim/
}

# Setup zoxide
setup_zoxide() {
    echo "Setting up Zoxide..."
    mkdir -p ~/.config/zoxide
    cp zoxide/config.toml ~/.config/zoxide/config.toml
}

# Setup alacritty
setup_alacritty() {
    echo "Setting up Alacritty..."
    mkdir -p ~/.config/alacritty
    cp alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
}

# Setup oh-my-posh
setup_ohmyposh() {
    echo "Setting up Oh My Posh..."
    mkdir -p ~/.config/oh-my-posh
    cp oh-my-posh/oh-my-posh.json ~/.config/oh-my-posh/oh-my-posh.json
}

# Setup zshrc
setup_zshrc() {
    echo "Setting up Zsh..."
    cp .zshrc ~/.zshrc
}

# Interactive prompt for each app
interactive_setup() {
    echo "Do you want to replace your tmux configuration? (yes/no)"
    read -r tmux_response
    if [[ "$tmux_response" == "yes" ]]; then
        setup_tmux
    fi

    echo "Do you want to replace your Neovim configuration? (yes/no)"
    read -r nvim_response
    if [[ "$nvim_response" == "yes" ]]; then
        setup_nvim
    fi

    echo "Do you want to replace your Zoxide configuration? (yes/no)"
    read -r zoxide_response
    if [[ "$zoxide_response" == "yes" ]]; then
        setup_zoxide
    fi

    echo "Do you want to replace your Alacritty configuration? (yes/no)"
    read -r alacritty_response
    if [[ "$alacritty_response" == "yes" ]]; then
        setup_alacritty
    fi

    echo "Do you want to replace your Oh My Posh configuration? (yes/no)"
    read -r ohmyposh_response
    if [[ "$ohmyposh_response" == "yes" ]]; then
        setup_ohmyposh
    fi

    echo "Do you want to replace your .zshrc file? (yes/no)"
    read -r zshrc_response
    if [[ "$zshrc_response" == "yes" ]]; then
        setup_zshrc
    fi
}

# Main setup
main() {
    echo "Welcome to the dotfiles setup script!"
    
    # Detect distribution
    check_distro

    # Install necessary packages
    install_packages

    # Perform interactive setup
    interactive_setup

    echo "Setup is complete. You can now press 'prefix + I' in tmux to install plugins."
    echo "For further setup, you can adjust individual configurations in ~/.config."
}

# Execute main function
main
