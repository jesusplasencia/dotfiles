#!/bin/sh
# Applies wallpapers via IPC — workaround for hyprpaper 0.8.x config/monitor race condition.
# Reads the first preload path from hyprpaper.conf so there is a single source of truth.
CONF="$HOME/.config/hypr/hyprpaper.conf"

while IFS= read -r line; do
    case "$line" in
        wallpaper\ =\ *)
            hyprctl hyprpaper wallpaper "${line#wallpaper = }"
            ;;
    esac
done < "$CONF"
