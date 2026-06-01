# ~/.config/fish/config.fish
# Fish shell configuration — Jesus Plasencia
# Sections: PATH · Aliases · Prompt

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
