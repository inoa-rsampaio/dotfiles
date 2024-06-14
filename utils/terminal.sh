#!/bin/bash

get_default_terminal() {
    update-alternatives --query x-terminal-emulator | grep 'Value:' | awk '{print $2}'
}

set_default_terminal() {
    set_terminal=$1
    terminal_name="${set_terminal##*/}"
    current_terminal=get_default_terminal

    if [ "$set_terminal" != "$current_terminal" ]; then
        echo "Setting Alacritty as the default terminal emulator ($set_terminal)..."
        sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $set_terminal 50
        sudo update-alternatives --config x-terminal-emulator

        gsettings set org.gnome.desktop.default-applications.terminal exec "$terminal_name"
        gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
    else
        echo "Alacritty is already the default terminal emulator."
    fi
}

set_default_shell() {
    zsh_path=$1
    current_shell=$(getent passwd $USER | awk -F: '{print $7}')

    if [ "$current_shell" != "$zsh_path" ]; then
        echo "Setting Zsh as the default shell ($zsh_path)..."
        if [ ! -L ~/.zshrc ]; then
            ln -s ~/.config/shell/zshrc ~/.zshrc > /dev/null
        fi

        echo >> ~/.bashrc
        echo '[ -n "$GNOME_TERMINAL_SCREEN" ] && [ -x "$(command -v zsh)" ] && exec zsh "$@"' >> ~/.bashrc
        sudo chsh -s $zsh_path
    else
        echo "Zsh is already the default shell."
    fi
}

set_git_config() {
    if [ ! -L ~/.gitconfig ]; then
        echo "Setting up git..."
        ln -s ~/.config/git/gitconfig ~/.gitconfig > /dev/null
        git config user.email $INOA_EMAIL
        git config user.name $INOA_NAME
    else
        echo "Git already configured"
    fi
}
