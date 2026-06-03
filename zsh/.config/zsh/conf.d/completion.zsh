autoload -Uz compinit && compinit

zstyle ':completion:*' menu select              # arrow-key navigation in completion menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive matching
zstyle ':completion:*' list-colors ''           # colorize completion list
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
