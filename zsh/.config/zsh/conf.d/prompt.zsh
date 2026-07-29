# Powerlevel10k right prompt configuration (removes status check, execution time, and clock)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# Starship prompt configuration (if used)
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
command -v starship &>/dev/null && eval "$(starship init zsh)"
