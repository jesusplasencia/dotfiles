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

## DP-1 black at cold boot — known hardware cause (not a config bug)

On this machine **DP-1 is an HDMI monitor connected through a cheap DP↔HDMI converter**
(motherboard DisplayPort → converter → monitor HDMI). The other identical monitor is on
the motherboard HDMI directly and works fine.

At cold boot the converter reports **`DPCD caps 0x0`** (`dmesg | grep DP-1`), i.e. it does
not expose its DisplayPort link capabilities in time. amdgpu therefore cannot train the DP
link (`/sys/kernel/debug/dri/*/DP-1/link_settings` shows `Current: 0 0x0 0`) and the panel
stays black until the monitor is **physically powered off/on**, which resets the converter
and makes it re-assert HPD so amdgpu re-reads a valid DPCD.

**This is a converter hardware limitation, not Hyprland.** The following were all tested
and cannot fix it — the PC has no way to reset the converter:

- `hyprctl keyword monitor "DP-1, disable"` + `hyprctl reload`
- `hyprctl dispatch dpms off/on DP-1`
- debugfs `echo 0/1 > .../DP-1/trigger_hotplug`
- forced retrain via `echo "4 0x14" > .../DP-1/link_settings`

### Real fixes (in order)
1. Use a monitor with a **native DisplayPort input** on the DP port (no converter).
2. Use a **better active converter** (Parade/Synaptics chipset) with correct cold-boot HPD.
3. Live with the manual monitor off/on.

> Side note: removing `splash` from the kernel cmdline (`/etc/default/limine`, then
> `sudo limine-update`) eliminated an unrelated `amdgpu dcn31_program_compbuf_size` boot
> WARNING. That is a host-level change, not tracked by this repo.

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
