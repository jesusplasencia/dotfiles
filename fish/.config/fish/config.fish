# ~/.config/fish/config.fish
# Fish shell configuration — Jesus Plasencia
# Sections: PATH · Aliases · Prompt

# ── SYSTEM ────────────────────────────────────────────────────────────────────
# CachyOS system config (no-op on other distros)
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# ── PATH ──────────────────────────────────────────────────────────────────────
fish_add_path $HOME/.local/bin

# ── ALIASES ───────────────────────────────────────────────────────────────────

# Dotfiles management
alias dotfiles 'cd ~/dotfiles'
alias stowit 'cd ~/dotfiles && stow */'
alias dots 'nvim ~/dotfiles'

# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias ll 'ls -lah --color=auto'
alias cat 'bat --style=plain'        # requires bat; use \cat to bypass

# Editor — point vim to nvim
alias vim 'nvim'

# Cloud / IaC
alias tf 'terraform'
alias tfp 'terraform plan'
alias tfa 'terraform apply'
alias tfd 'terraform destroy'
alias awsid 'aws sts get-caller-identity'

# Shell
alias reload 'source ~/.config/fish/config.fish'

# ── PROMPT ────────────────────────────────────────────────────────────────────
# Prompt managed by starship — initialised below if installed
if command -v starship > /dev/null
    # Initialise starship prompt for fish
    starship init fish | source
end

# ── TOOLS ─────────────────────────────────────────────────────────────────────
# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
