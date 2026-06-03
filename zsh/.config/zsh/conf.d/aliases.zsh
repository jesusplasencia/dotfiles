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
