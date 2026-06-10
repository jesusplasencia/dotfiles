# waybar

Status bar for Hyprland. Autostarted by `hyprland.conf` (`exec-once = waybar`).

---

## What's included

```
waybar/
└── .config/waybar/
    ├── config.jsonc   — module layout and behaviour
    └── style.css      — kanagawa-dragon theme
```

## Layout

```
[ workspaces ]          [ clock ]          [ audio · network · cpu · memory · battery · tray ]
```

| Position | Modules |
|----------|---------|
| Left | `hyprland/workspaces` — clickable workspace numbers |
| Center | `clock` — `Mon Jun 09  14:30`, hover for calendar |
| Right | `pulseaudio`, `network`, `cpu`, `memory`, `battery`, `tray` |

## Customization

### Move or remove a module — `config.jsonc`

Edit the three `modules-*` arrays at the top of the file:

```jsonc
"modules-left":   ["hyprland/workspaces"],
"modules-center": ["clock"],
"modules-right":  ["pulseaudio", "network", "cpu", "memory", "battery", "tray"]
```

Remove a module name to hide it. Order within the array sets display order.

### Change polling intervals — `config.jsonc`

Each module has an `interval` key (in seconds):

```jsonc
"cpu":    { "interval": 5  },
"memory": { "interval": 10 }
```

### Colors — `style.css`

All colors follow the kanagawa-dragon palette defined in the header comment:

```css
/* Dragon bg: #181616  fg: #c5c9c5  blue: #7fb4ca  green: #98bb6c
   yellow: #e6c384     red: #c34043  orange: #ffa066  muted: #625e5a */
```

Each module has its own `#id { color: ...; }` rule at the bottom of `style.css`. Change any hex value there to retheme a single module without touching the others.

### Bar position — `config.jsonc`

```jsonc
"position": "top"   // change to "bottom" to move the bar
```

### Bar size and margins — `config.jsonc`

```jsonc
"height": 32,
"margin-top": 6,
"margin-left": 12,
"margin-right": 12
```

## Reload after changes

Waybar reads its config on startup. To apply changes without rebooting:

```bash
pkill waybar && waybar &
```

Or add a keybind in `hyprland.conf`:

```ini
bind = $mainMod SHIFT, B, exec, pkill waybar && waybar &
```
