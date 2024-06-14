#!/bin/bash

set_inoa_bg() {
    if [ ! -f ~/bg.png ]; then
        echo "Adding inoa wallpaper"
        cp ./appearance/wallpaper.png ~/.inoa/

        echo "Ensuring desktop app description for snapd apps"
        user_apps="$HOME/.local/share/applications"
        for snap_desktop_file in /var/lib/snapd/desktop/applications/*.desktop; do
            file_name="${snap_desktop_file##*/}"

            if [ ! -L "$user_apps/$file_name" ]; then
                ln -s "$snap_desktop_file" "$user_apps/$file_name"
            fi
        done

        gsettings set org.gnome.desktop.background picture-uri file://$HOME/.inoa/wallpaper.png

        DOCK_APPS=(
            'alacritty'
            'google-chrome'
            'pop-cosmic-launcher'
            'pop-cosmic-workspaces'
            'pop-cosmic-applications'
            'code_code'
            'rider_rider'
            'obsidian_obsidian'
            'remmina_remmina'
            'telegram-desktop_telegram-desktop'
            'org.gnome.Nautilus'
            'gnome-control-center'
        )

        docks_app_join="["
        for app in "${DOCK_APPS[@]}"; do
            docks_app_join+="'${app}.desktop',"
        done
        docks_app_join="${docks_app_join%,}]"

        echo "Setting docks as: $docks_app_join"

        gsettings set org.gnome.shell favorite-apps "$docks_app_join"
    fi
}

setup_dock() {

    if gsettings get org.gnome.shell favorite-apps | grep appcenter; then 
        echo -e "${CYAN}Setting up dock apps${NC}"
        gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36

        gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
    fi
}

