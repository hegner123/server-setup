#!/usr/bin/env bash

install_zsh() {
    apt install zsh
}

install_neovim() {
    apt install neovim
}

install_zoxide() {
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

config_zsh() {

    cd ~
    rm .zshrc
    git clone https://github.com/hegner123/zsh-setup.git
    ln -sf ~/zsh-setup/.zshrc ~/.zshrc

    # Expected output
    expected_output="$HOME/.zshrc -> $HOME/zsh-setup/.zshrc"

    # Actual output
    actual_output=$(ls -l ~/.zshrc | awk '{print $9, $10, $11}')

    # Check if the output matches
    if [[ "$actual_output" == "$expected_output" ]]; then
        echo ".zshrc successfully linked"
    else
        echo "Test failed: .zshrc is not correctly symlinked."
        echo "Expected: $expected_output"
        echo "Actual:   $actual_output"
        exit 1
    fi
}
config_mhNvim() {
    mkdir ~/.config
    ln -sf ~/.config/mhvim ~/.config/nvim

    git clone https://github.com/hegner123/mhNvim
    expected_output="$HOME/.config/nvim -> $HOME/.config/mhNvim"

    actual_output=$(ls -l ~/.zshrc | awk '{print $9, $10, $11}')

    if [[ "$actual_output" == "$expected_output" ]]; then
        echo "mhNvim successfully linked"
    else
        echo "Test failed: .mhnvim is not correctly symlinked."
        echo "Expected: $expected_output"
        echo "Actual:   $actual_output"
        exit 1
    fi
}

install_eza() {
    sudo apt update
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
}

install_omz() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Programs to check
programs=("zsh" "zoxide" "eza" "neovim" "omz")
allinstalled=false
allconfig=false
toinstall=()
toconfig=()

echo "Checking programs:"
for prog in "${programs[@]}"; do
    if command -v "$prog" &>/dev/null; then
        echo "$prog is installed."
    else
        echo "$prog is not installed."
        toinstall+=("$prog")
    fi
done

# Configuration files to check
config_files=("~/zsh-setup/.zshrc" "~/.config/nvim/init.lua")
configs=("zshrc" "mhNvim")

echo "Checking configuration files:"
for file in "${config_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "$file exists."
    else
        echo "$file does not exist."
        case "$file" in
        "~/zsh-setup/.zshrc")
            toconfig+=("zshrc")
            ;;
        "~/.config/nvim/init.lua")
            toconfig+=("mhNvim")
            ;;
        *)
            echo "$file does not match install function"
            ;;
        esac
    fi
done

echo "install programs:"
for prog in "${toinstall[@]}"; do
    case "$prog" in
    "zsh")
        echo "installing zsh"
        install_zsh
        ;;
    "omz")
        echo "installing ohmyzsh"
        install_omz
        ;;
    "neovim")
        echo "installing neovim"
        install_neovim
        ;;
    "zoxide")
        echo "installing zoxide"
        install_zoxide
        ;;
    "eza")
        echo "installing eza"
        install_eza
        ;;
    *)
        echo "$prog does not match install function"
        ;;
    esac
done

echo "install config:"
for conf in "${toconfig[@]}"; do
    case "$conf" in
    "zshrc")
        echo "installing zshrc"
        config_zsh
        ;;
    "mhNvim")
        echo "installing mhNvim"
        config_mhNvim
        ;;
    *)
        echo "$conf does not match install function"
        ;;
    esac
done
