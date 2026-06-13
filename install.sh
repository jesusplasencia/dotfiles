#!/usr/bin/env bash
# install.sh — idempotent bootstrap for Jesus Plasencia's dotfiles
# Safe to run multiple times. Prints [OK] / [SKIP] / [ERROR] per step.
# Usage: bash install.sh
# Ref: CLAUDE.md § install.sh Conventions

set -euo pipefail

OK="[OK]"
SKIP="[SKIP]"
ERR="[ERROR]"

log()  { printf '%s %s\n' "$1" "$2"; }
ok()   { log "$OK"   "$*"; }
skip() { log "$SKIP" "$*"; }
err()  { log "$ERR"  "$*" >&2; }

# ── 0. OS CHECK ───────────────────────────────────────────────────────────────
if ! grep -qi 'arch\|cachyos\|manjaro' /etc/os-release 2>/dev/null; then
    err "This script targets Arch/CachyOS. Proceeding anyway — pacman steps may fail."
fi

# ── 1. SYSTEM PACKAGES (pacman) ───────────────────────────────────────────────
PACMAN_PKGS=(
    zsh git stow
    alacritty neovim starship tmux
    github-cli ripgrep fzf bat
    bun
    pipewire wireplumber playerctl brightnessctl
    waybar wofi dunst network-manager-applet
    hyprland hyprpaper
    rofi-wayland
    grim slurp wl-clipboard
)

if command -v pacman &>/dev/null; then
    MISSING=()
    for pkg in "${PACMAN_PKGS[@]}"; do
        pacman -Q "$pkg" &>/dev/null || MISSING+=("$pkg")
    done
    if [[ ${#MISSING[@]} -eq 0 ]]; then
        skip "All system packages already installed"
    else
        ok "Installing system packages: ${MISSING[*]}"
        sudo pacman -S --needed --noconfirm "${MISSING[@]}"
    fi
else
    skip "pacman not found — skipping system packages"
fi

# ── 2. AUR PACKAGES (paru) ────────────────────────────────────────────────────
AUR_PKGS=(
    ttf-jetbrains-mono-nerd
    brave-bin
    aws-cli-v2
    terraform
    tflint
    tfsec
    infracost
)

if command -v paru &>/dev/null; then
    AUR_MISSING=()
    for pkg in "${AUR_PKGS[@]}"; do
        paru -Q "$pkg" &>/dev/null || AUR_MISSING+=("$pkg")
    done
    if [[ ${#AUR_MISSING[@]} -eq 0 ]]; then
        skip "All AUR packages already installed"
    else
        ok "Installing AUR packages: ${AUR_MISSING[*]}"
        paru -S --needed --noconfirm "${AUR_MISSING[@]}"
    fi
else
    skip "paru not found — skipping AUR packages (install paru first, then re-run)"
fi

# ── 3. STOW ───────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f .stowrc ]]; then
    echo "--target=$HOME" > .stowrc
    ok "Created .stowrc targeting $HOME"
else
    skip ".stowrc already exists"
fi

STOW_PKGS=(zsh nvim alacritty git tmux hypr rofi waybar aws)
ok "Stowing packages: ${STOW_PKGS[*]}"
stow --restow "${STOW_PKGS[@]}"

# ── 4. ZSH PLUGINS ────────────────────────────────────────────────────────────
PLUGIN_DIR="$HOME/.config/zsh/plugins"
mkdir -p "$PLUGIN_DIR"

if [[ -d "$PLUGIN_DIR/zsh-autosuggestions" ]]; then
    skip "zsh-autosuggestions already cloned"
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$PLUGIN_DIR/zsh-autosuggestions"
    ok "Cloned zsh-autosuggestions"
fi

if [[ -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]]; then
    skip "zsh-syntax-highlighting already cloned"
else
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
        "$PLUGIN_DIR/zsh-syntax-highlighting"
    ok "Cloned zsh-syntax-highlighting"
fi

# ── 5. TPM (tmux plugin manager) ──────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
    skip "TPM already installed"
else
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "Cloned TPM — start tmux and press Ctrl+b I to install plugins"
fi

# ── 6. GIT IDENTITY ───────────────────────────────────────────────────────────
if [[ -f "$HOME/.gitconfig.local" ]]; then
    skip "~/.gitconfig.local already exists"
else
    ok "Running setup-git.sh to create ~/.gitconfig.local"
    bash "$SCRIPT_DIR/scripts/setup-git.sh"
fi

# ── 7. DIRECTORIES ────────────────────────────────────────────────────────────
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Pictures/wallpapers"
ok "Ensured ~/Pictures/Screenshots and ~/Pictures/wallpapers exist"

# ── 8. USER SCRIPTS (~/.local/bin) ────────────────────────────────────────────
# Expose utility scripts as global commands via symlink. ~/.local/bin is on PATH.
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

link_script() {  # link_script <script-name.sh> <command-name>
    src="$SCRIPT_DIR/scripts/$1"
    dst="$BIN_DIR/$2"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        skip "$2 already linked"
    else
        ln -sf "$src" "$dst"
        chmod +x "$src"
        ok "Linked $2 → $src"
    fi
}

link_script new-project.sh new-project

# ── 9. DEFAULT SHELL ──────────────────────────────────────────────────────────
if [[ "$SHELL" == "/bin/zsh" ]]; then
    skip "zsh is already the default shell"
else
    ok "Setting zsh as default shell (may prompt for password)"
    chsh -s /bin/zsh
fi

# ── POST-INSTALL ──────────────────────────────────────────────────────────────
cat <<'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Manual steps remaining:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. Copy and edit machine-specific Hyprland configs:
      cp hypr/.config/hypr/monitors.conf.example hypr/.config/hypr/monitors.conf
      cp hypr/.config/hypr/hyprpaper.conf.example hypr/.config/hypr/hyprpaper.conf

 2. Install tmux plugins:
      tmux  →  Ctrl+b I

 3. Authenticate:
      gh auth login
      aws configure sso   (once per SSO profile)

 4. Install miniforge3 for conda/mamba (optional):
      See INSTALL.md § 4f

 5. Re-login or: exec zsh
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
