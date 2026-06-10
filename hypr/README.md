# hypr

Hyprland window manager configuration — keybinds, autostart, wallpaper, and monitor layout.

## Stow

With `.stowrc` configured (see root README), run from the repo root:

```bash
stow hypr
```

Creates symlinks:
- `~/.config/hypr/hyprland.conf` → `hypr/.config/hypr/hyprland.conf`
- `~/.config/hypr/set-wallpaper.sh` → `hypr/.config/hypr/set-wallpaper.sh`

> `hyprpaper.conf` and `monitors.conf` are machine-specific and not stowed — copy from their `.example` files instead (see below).

## Monitor layout (machine-specific)

Monitor config is not committed — copy the example and edit for your displays:

```bash
cp hypr/.config/hypr/monitors.conf.example hypr/.config/hypr/monitors.conf
nvim hypr/.config/hypr/monitors.conf
```

## Dual monitors with identical EDID

Both displays here report the same make/model/serial, so Hyprland's boot-time output
negotiation is fragile and **DP-1 can come up asleep** (black until you power the monitor
off and on). `hyprland.conf` fixes this entirely on the compositor side:

```
exec-once = sh -c 'sleep 2 && hyprctl keyword monitor "DP-1, disable" && sleep 1 && hyprctl reload'
```

This disables DP-1, then `hyprctl reload` re-applies `monitors.conf` and re-enables it —
a fresh modeset that wakes the panel, mimicking a physical off/on. `monitors.conf` stays
the single source of truth for resolution/position.

> A kernel-level disable (`video=DP-1:d` in the bootloader cmdline) is intentionally
> **not** used: it force-offs the connector at KMS, so the panel stays asleep until a
> hotplug even after Hyprland enables it — and it ties the fix to the bootloader. Keeping
> the fix in `hyprland.conf` makes it portable to any distro (Arch, Fedora, …).

## Wallpaper

`hyprpaper.conf` is not committed (machine-specific — hyprpaper cannot expand `$HOME`).
Copy the example and replace `YOUR_USER` with your username:

```bash
cp hypr/.config/hypr/hyprpaper.conf.example hypr/.config/hypr/hyprpaper.conf
nvim hypr/.config/hypr/hyprpaper.conf
```

Place wallpaper images at `~/Pictures/wallpapers/` before starting hyprpaper.

Apply changes live without rebooting:

```bash
~/.config/hypr/set-wallpaper.sh
```

> **Note:** hyprpaper 0.8.x has a race condition where it processes monitor events before reading its config. `set-wallpaper.sh` works around this by applying wallpapers via IPC after startup. It is called automatically at boot from the monitor reset chain in `hyprland.conf`.
