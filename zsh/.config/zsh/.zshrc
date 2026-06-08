# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.config/zsh/.zshrc
# Zsh configuration — Jesus Plasencia
# Sections: Options · Plugins · conf.d

# ── OPTIONS ───────────────────────────────────────────────────────────────────
setopt AUTO_CD              # cd by typing directory name
setopt HIST_IGNORE_DUPS     # skip duplicate consecutive history entries
setopt HIST_IGNORE_SPACE    # skip entries starting with a space
setopt SHARE_HISTORY        # share history across sessions
setopt EXTENDED_HISTORY     # record timestamp in history
setopt INTERACTIVE_COMMENTS # allow # comments in interactive shell

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# ── SYSTEM ────────────────────────────────────────────────────────────────────
# CachyOS system config (no-op on other distros)
[[ -f /usr/share/cachyos-zsh-config/cachyos-config.zsh ]] && \
    source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ── PLUGINS ───────────────────────────────────────────────────────────────────
# Clone with: git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
# Clone with: git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
[[ -f $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── CONF.D ────────────────────────────────────────────────────────────────────
for f in $ZDOTDIR/conf.d/*.zsh; do
    [[ -f $f ]] && source $f
done

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

