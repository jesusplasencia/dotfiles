# alacritty

GPU-accelerated terminal emulator configuration.

## What's included

- JetBrainsMono Nerd Font at 11pt (regular, bold, italic)
- 8px window padding on all sides
- No window decorations (relies on the compositor — Hyprland)
- 10,000 line scrollback history
- Zsh as the default shell

## Prerequisites

| Dependency | Install (Arch) | Install (Fedora) | Install (macOS) |
|---|---|---|---|
| alacritty | `paru -S alacritty` | `dnf install alacritty` | `brew install alacritty` |
| JetBrainsMono Nerd Font | `paru -S ttf-jetbrains-mono-nerd` | `dnf install jetbrains-mono-fonts` | `brew install --cask font-jetbrains-mono-nerd-font` |
| zsh | `paru -S zsh` | `dnf install zsh` | pre-installed |

> On Fedora and macOS, verify the font family name matches exactly what's in `alacritty.toml` — it must be `"JetBrainsMono Nerd Font"`.

## Stow setup

```bash
cd ~/dotfiles
stow alacritty
```

Creates the symlink:

```
~/.config/alacritty/alacritty.toml → ~/dotfiles/alacritty/.config/alacritty/alacritty.toml
```

## Configuration reference

```toml
[window]
padding.x = 8          # horizontal inner padding (pixels)
padding.y = 8          # vertical inner padding (pixels)
decorations = "None"   # no title bar — Hyprland handles window chrome
opacity = 1            # 0.0 (transparent) → 1.0 (opaque)
startup_mode = "Windowed"

[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
bold   = { family = "JetBrainsMono Nerd Font", style = "Bold" }
italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
size = 11.0            # adjust per monitor DPI

[scrolling]
history = 10000        # lines kept in scrollback buffer

[terminal]
shell = { program = "/bin/zsh" }
```

## Common adjustments

**Increase font size for HiDPI displays:**
```toml
[font]
size = 14.0
```

**Enable slight transparency:**
```toml
[window]
opacity = 0.95
```

**Use a different font (must be a Nerd Font for icon glyphs):**
```toml
[font]
normal = { family = "FiraCode Nerd Font", style = "Regular" }
```

**Keep decorations on non-Hyprland desktops:**
```toml
[window]
decorations = "Full"
```

## Notes

- `decorations = "None"` depends on the compositor for window borders and title bars. On GNOME, KDE, or macOS, set this to `"Full"` or remove the line entirely.
- Alacritty does not support tabs — use tmux for multiplexing (see `tmux/`).
- Always edit the source file inside the repo, never the symlinked file in `~/.config/`.
