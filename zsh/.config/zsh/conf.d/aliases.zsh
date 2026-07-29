# ── Dotfiles management ───────────────────────────────────────────────────────
alias dotfiles='cd ~/dotfiles'
alias stowit='cd ~/dotfiles && stow */'
alias dots='nvim ~/dotfiles'

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias cat='bat --style=plain'        # requires bat; use \cat to bypass

# ── Editor ────────────────────────────────────────────────────────────────────
alias vim='nvim'

# ── Cloud / IaC ───────────────────────────────────────────────────────────────
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias awsid='aws sts get-caller-identity'

# Switch AWS profile and verify identity
awsp() {
    export AWS_PROFILE="$1"
    aws sts get-caller-identity
}

# ── Shell ─────────────────────────────────────────────────────────────────────
alias reload='source $ZDOTDIR/.zshrc'

# Pull dotfiles, update system packages, and refresh tmux + nvim plugins
upgrade() {
    echo "==> dotfiles pull"
    git -C ~/dotfiles pull --ff-only

    echo "==> system packages"
    paru -Syu --noconfirm

    echo "==> tmux plugins"
    ~/.tmux/plugins/tpm/bin/update_plugins all

    echo "==> nvim packs"
    nvim --headless "+lua vim.pack.update()" +qa 2>/dev/null || true

    echo "==> done"
}

# ── Tmux ──────────────────────────────────────────────────────────────────────
# Create or attach to a tmux session starting in the current working directory
tn() {
    local session_name="${1:-$(basename "$PWD")}"
    if [ -n "$TMUX" ]; then
        # Inside tmux: create session in background and switch client (prevents nesting)
        tmux has-session -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" -c "$PWD"
        tmux switch-client -t "$session_name"
    else
        # Outside tmux: attach if session exists, otherwise create new session in $PWD
        tmux has-session -t "$session_name" 2>/dev/null && tmux attach-session -t "$session_name" || tmux new-session -s "$session_name" -c "$PWD"
    fi
}

