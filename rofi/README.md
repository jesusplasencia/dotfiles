# rofi

App launcher and power menu. Current scope: power menu only (Super+M).

---

## What's included

```
rofi/
└── .config/rofi/
    ├── themes/
    │   └── power-menu.rasi   — Catppuccin-style dark theme
    └── scripts/
        └── power-menu.sh     — Shutdown / Restart menu
```

## Keybind

`Super+M` → power menu — set in `hypr/.config/hypr/hyprland.conf`.

---

## Customization

### Colors — `themes/power-menu.rasi`

All colors are defined at the top of the file as variables:

```rasi
* {
    bg:      #1e1e2e;   /* window background          */
    bg-alt:  #313244;   /* unselected entry background */
    fg:      #cdd6f4;   /* text color                 */
    accent:  #89b4fa;   /* selected entry highlight   */
    border:  #45475a;   /* window border              */
}
```

Change any hex value to retheme the entire menu without touching anything else.

### Adding menu entries — `scripts/power-menu.sh`

1. Add a new line to the `printf` call:
   ```bash
   printf "󰐥  Apagar\n󰑓  Reiniciar\n󰍃  Sair"
   ```
2. Add a matching `case` branch:
   ```bash
   *"Sair") loginctl terminate-user "$USER" ;;
   ```
3. Bump `-lines N` to match the new total count.

Icons require a Nerd Font — the default is JetBrainsMono Nerd Font.

### Font — `themes/power-menu.rasi`

Find and edit the `font:` line inside `element-text {}`:

```rasi
element-text {
    font: "JetBrainsMono Nerd Font 13";
}
```

Any installed Nerd Font family name works here.

### Window size / position

`window {}` in `power-menu.rasi` controls placement:

```rasi
window {
    width:    280px;
    location: center;
    anchor:   center;
}
```

Change `location` / `anchor` to `north`, `south`, `east`, `west`, or any corner
(`north east`, etc.) to reposition the menu.
