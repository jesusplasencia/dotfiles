#!/usr/bin/env bash

choice=$(printf "󰐥  Apagar\n󰑓  Reiniciar" | rofi -dmenu \
    -p "" \
    -theme "$HOME/.config/rofi/themes/power-menu.rasi" \
    -no-custom \
    -lines 2)

case "$choice" in
    *"Apagar")    systemctl poweroff ;;
    *"Reiniciar") systemctl reboot   ;;
esac
