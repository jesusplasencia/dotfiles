# hypr

Hyprland window manager configuration — keybinds, autostart, wallpaper, and monitor layout.

## Stow

```bash
cd ~/dotfiles
stow --target="$HOME" hypr/
```

Creates symlinks:
- `~/.config/hypr/hyprland.conf` → `hypr/.config/hypr/hyprland.conf`
- `~/.config/hypr/hyprpaper.conf` → `hypr/.config/hypr/hyprpaper.conf`
- `~/.config/hypr/set-wallpaper.sh` → `hypr/.config/hypr/set-wallpaper.sh`

## Monitor layout (machine-specific)

Monitor config is not committed — copy the example and edit for your displays:

```bash
cp ~/.config/hypr/monitors.conf.example ~/.config/hypr/monitors.conf
nvim ~/.config/hypr/monitors.conf
```

## Wallpaper

Wallpapers are configured in `hyprpaper.conf`. Place images anywhere (recommended: `~/Pictures/wallpapers/`) and update the paths:

```ini
preload = /home/jplasencia/Pictures/wallpapers/Blue.jpg

wallpaper = DP-1,/home/jplasencia/Pictures/wallpapers/Blue.jpg
wallpaper = HDMI-A-1,/home/jplasencia/Pictures/wallpapers/Blue.jpg
```

Apply changes live without rebooting:

```bash
~/.config/hypr/set-wallpaper.sh
```

> **Note:** hyprpaper 0.8.x has a race condition where it processes monitor events before reading its config. `set-wallpaper.sh` works around this by applying wallpapers via IPC after startup. It is called automatically at boot from the monitor reset chain in `hyprland.conf`.
