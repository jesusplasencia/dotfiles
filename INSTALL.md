# INSTALL — Fresh System Setup

> Jesus Plasencia · Personal environment  
> Managed with GNU Stow — symlinks only, no scripts touching home directly.

---

## Compatibility

| Layer | Arch Linux / CachyOS | Fedora Cosmic |
|-------|----------------------|---------------|
| Shell (zsh + starship) | ✅ Full | ✅ Full |
| Editor (neovim) | ✅ Full | ✅ Full |
| Terminal (alacritty) | ✅ Full | ✅ Full |
| Git config | ✅ Full | ✅ Full |
| Cloud / IaC tools | ✅ Full | ⚠️ Manual installs (see Step 2) |
| Python env (conda/mamba) | ✅ Full | ✅ Full |
| Desktop (Hyprland stack) | ✅ Full | ❌ Not applicable — Cosmic has its own compositor |

**Fedora Cosmic:** stow only the `zsh`, `nvim`, `alacritty`, `git` packages. Skip `hypr/`.

---

## Step 0 — Clone & configure Stow

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Create the stow target file (machine-specific, gitignored)
echo "--target=$HOME" > .stowrc
```

---

## Step 1 — System packages

### Arch Linux / CachyOS

```bash
sudo pacman -S \
  zsh git stow \
  alacritty neovim starship tmux \
  github-cli ripgrep fzf bat \
  pipewire wireplumber playerctl brightnessctl \
  waybar wofi dunst network-manager-applet \
  hyprland hyprpaper \
  rofi-wayland \
  grim slurp wl-clipboard
```

### Fedora

```bash
sudo dnf install \
  zsh git stow \
  alacritty neovim starship tmux \
  gh ripgrep fzf bat \
  pipewire wireplumber playerctl brightnessctl \
  waybar wofi dunst network-manager-applet \
  rofi-wayland \
  grim slurp wl-clipboard
```

> Hyprland on Fedora requires a COPR. Skip if using Cosmic DE.
>
> ```bash
> sudo dnf copr enable solopasha/hyprland
> sudo dnf install hyprland hyprpaper
> ```

---

## Step 2 — AUR / manual installs

### Arch: install paru (AUR helper) first

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru && makepkg -si
```

### Arch: AUR packages

```bash
paru -S \
  ttf-jetbrains-mono-nerd \
  brave-bin \
  aws-cli-v2 \
  terraform \
  tflint \
  tfsec \
  infracost
```

### Fedora: manual installs for cloud tools

```bash
# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip /tmp/awscliv2.zip -d /tmp && sudo /tmp/aws/install

# Terraform (HashiCorp repo)
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install terraform

# tflint, tfsec, infracost — use their official install scripts or GitHub releases
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
curl -fsSL https://www.infracost.io/install.sh | sh

# JetBrainsMono Nerd Font — download from nerdfonts.com and install to ~/.local/share/fonts/
```

### Brave browser (Fedora)

```bash
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser
```

---

## Step 3 — Stow (create symlinks)

From the repo root:

```bash
# Full setup (Arch + Hyprland)
stow zsh nvim alacritty git hypr tmux rofi waybar aws

# Shell + dev only (Fedora Cosmic or any non-Hyprland system)
stow zsh nvim alacritty git tmux rofi aws
```

---

## Step 4 — Post-stow configuration

### 4a. Zsh — set as default shell + clone plugins

```bash
chsh -s /bin/zsh

# Clone plugins (no plugin manager — loaded directly by .zshrc)
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.config/zsh/plugins/zsh-syntax-highlighting
```

### 4b. Git — create local identity file

```bash
bash ~/dotfiles/scripts/setup-git.sh
# Prompts for name and email → creates ~/.gitconfig.local (gitignored)
```

### 4c. Neovim — first launch auto-installs plugins

```bash
nvim  # plugins clone automatically on first open, then :q
```

### 4d. Hyprland — machine-specific configs (Arch only)

```bash
# Monitor layout
cp ~/dotfiles/hypr/.config/hypr/monitors.conf.example \
   ~/dotfiles/hypr/.config/hypr/monitors.conf
# Edit monitors.conf: set your actual monitor names, resolutions, positions
nvim ~/dotfiles/hypr/.config/hypr/monitors.conf

# Wallpaper config
cp ~/dotfiles/hypr/.config/hypr/hyprpaper.conf.example \
   ~/dotfiles/hypr/.config/hypr/hyprpaper.conf
# Edit hyprpaper.conf: replace YOUR_USER with your username and set wallpaper paths
nvim ~/dotfiles/hypr/.config/hypr/hyprpaper.conf
```

### 4e. Wallpapers

```bash
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Pictures/wallpapers
# Copy or download your wallpapers into ~/Pictures/wallpapers/
# The hyprpaper config references Blue.jpg and Red.jpg by default
```

### 4f. Python env — install miniforge3

```bash
curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
  -o /tmp/miniforge3.sh
bash /tmp/miniforge3.sh -b -p "$HOME/miniforge3"
# Restart shell — conda.zsh in conf.d initializes it automatically
```

### 4g. tmux — install TPM and plugins

```bash
# Clone TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux, then press Ctrl+b I to install all plugins
tmux
```

First-launch sequence: `tmux` → `Ctrl+b I` → wait for plugins to install → done.

After a reboot, run `tmux attach` to restore your previous session (tmux-continuum).

### 4h. Auth

```bash
gh auth login          # GitHub CLI
aws configure sso      # AWS SSO (run once per profile)
```

---

## Verification checklist

Run these after a fresh install to confirm everything is working:

- [ ] `zsh --version` — shell available
- [ ] `nvim --version` — neovim ≥ 0.12; open it and verify kanagawa theme loads
- [ ] `starship --version` — prompt renders in zsh
- [ ] `stow --version` — symlink manager present
- [ ] Open alacritty → JetBrainsMono Nerd Font renders correctly
- [ ] `conda activate base` → no errors (requires miniforge3)
- [ ] `gh auth status` → authenticated to GitHub
- [ ] `aws sts get-caller-identity` → returns your account ID
- [ ] `tf version` (alias for terraform) → IaC toolchain works
- [ ] `hyprctl version` (Arch only) → Hyprland running
- [ ] Press `Print` → screenshot saved to `~/Pictures/Screenshots/`
- [ ] `bat ~/.zshrc` → syntax highlighting confirms bat alias works
- [ ] `tmux new -s test` → session opens, status bar shows kanagawa-dragon theme
- [ ] `Ctrl+b |` → vertical split; `Ctrl+b -` → horizontal split
- [ ] `Ctrl+h/j/k/l` → navigate between panes (seamless with nvim splits)
- [ ] `Ctrl+b d` → detach; `tmux attach` → session restored
