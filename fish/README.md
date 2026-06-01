# fish

Fish shell configuration with aliases, PATH setup, and starship prompt integration.

## What's included

- All standard dotfiles aliases (navigation, cloud/IaC, dotfiles management)
- `vim` → `nvim` alias
- `bat` as `cat` replacement (with `\cat` escape hatch)
- Starship prompt (auto-detected, no-op if not installed)
- `conf.d/` directory for machine-local overrides (gitignored)

## Prerequisites

- **fish** — `yay -S fish`
- **starship** — `yay -S starship` (prompt; skipped gracefully if absent)
- **bat** — `yay -S bat` (used by the `cat` alias)

## Stow setup

```bash
cd ~/dotfiles
stow fish
```

This creates the symlink `~/.config/fish/config.fish → ~/dotfiles/fish/.config/fish/config.fish`
and the `conf.d/` directory.

## Set fish as your default shell

```bash
chsh -s $(which fish)
# Log out and back in for the change to take effect
```

## Machine-specific secrets and overrides

Fish automatically sources every `*.fish` file inside `~/.config/fish/conf.d/`.
Create a `local.fish` there for anything that must not be committed:

```fish
# ~/.config/fish/conf.d/local.fish  ← gitignored, never committed
set -x AWS_PROFILE my-profile
set -x GITHUB_TOKEN ghp_xxxx
```

This file is intentionally excluded from the repo via `.gitignore`.

## Reload after changes

```bash
reload   # alias for: source ~/.config/fish/config.fish
```

Or open a new terminal session.
