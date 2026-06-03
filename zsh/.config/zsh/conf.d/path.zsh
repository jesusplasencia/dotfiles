# PATH additions
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME/bin:"* ]] && export PATH="$PNPM_HOME/bin:$PATH"
