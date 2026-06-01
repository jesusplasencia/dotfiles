# dotfiles

Jesus Plasencia · Personal environment — CachyOS / Arch-based

## First-time setup (fresh clone)

### 1. Clone

```bash
git clone <repo-url> ~/dotfiles   # or wherever you prefer
cd ~/dotfiles
```

### 2. Create `.stowrc` (required — gitignored)

Stow's default target is the parent of the repo directory, which is only correct when the
repo lives at `~/dotfiles`. The `.stowrc` file pins the target to `$HOME` regardless of
where the repo is cloned. It's gitignored because the path is machine-specific.

```bash
echo "--target=$HOME" > .stowrc
```

### 3. Set up wallpapers

```bash
mkdir -p ~/Pictures/wallpapers
# Copy your wallpapers there — Blue.jpg and Red.jpg are referenced by default
```

### 4. Copy machine-specific configs

```bash
# Monitor layout
cp hypr/.config/hypr/monitors.conf.example hypr/.config/hypr/monitors.conf
nvim hypr/.config/hypr/monitors.conf

# Wallpaper config — hyprpaper does not expand $HOME, so paths must be absolute
cp hypr/.config/hypr/hyprpaper.conf.example hypr/.config/hypr/hyprpaper.conf
nvim hypr/.config/hypr/hyprpaper.conf   # replace YOUR_USER with your username

# Git identity
# ~/.gitconfig.local is sourced by .gitconfig but never committed
bash scripts/setup-git.sh
```

### 5. Stow packages

```bash
stow alacritty fish git hypr nvim
# or stow */ to stow everything at once
```

### 6. Post-install

- Set fish as default shell: `chsh -s /bin/fish`
- Restart or re-login for the shell change to take effect
- Configure AWS SSO: `aws configure sso`
- GitHub auth: `gh auth login`
- Create `~/.config/fish/conf.d/local.fish` for API keys and secrets (gitignored)

---

## Packages

| Package      | What it configures                                    |
|--------------|-------------------------------------------------------|
| `alacritty/` | Terminal — font, opacity, fish shell                  |
| `fish/`      | Fish shell — aliases, PATH, starship prompt           |
| `git/`       | Global gitconfig + aliases                            |
| `hypr/`      | Hyprland, hyprpaper, keybinds, autostart              |
| `nvim/`      | Neovim — LazyVim bootstrap, colorcolumn, tokyonight   |

---

## Stow cheatsheet

| Command          | Effect                                        |
|------------------|-----------------------------------------------|
| `stow <pkg>`     | Symlink package into `$HOME`                  |
| `stow -D <pkg>`  | Remove symlinks (**destructive** — use with care) |
| `stow */`        | Stow all packages at once                     |

> `.stowrc` (gitignored) sets `--target=$HOME` so stow works from any clone location.
> Never edit symlinked files in `~/` directly — always edit the source inside this repo.
