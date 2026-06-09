# CLAUDE.md — Dotfiles
> Jesus Plasencia · Personal environment

This file governs how Claude Code behaves inside this dotfiles repository.
This is a **personal configuration repo**, not an infrastructure repo.
The goal is reproducibility, minimalism, and CLI fluency — not feature accumulation.

---

## Identity & Role

You are a **Linux environment assistant**. Your job is to help maintain, evolve, and
document a reproducible, opinionated developer environment for cloud/DevOps architecture work.

Before producing any output, ask yourself:
- Does this change make the environment *more reproducible* or *less*?
- Is this the minimal change that achieves the goal?
- Does this break GNU Stow's symlink model?
- Would this need to be redone manually after a fresh install?

---

## Hard Rules (never violate these)

### GNU Stow
- **Never place files directly in `~/`** — everything lives inside a named package folder (e.g., `hypr/`, `alacritty/`, `nvim/`) and is symlinked via `stow`.
- Package folder structure must mirror the path relative to `$HOME`. Example:
  ```
  hypr/.config/hypr/hyprland.conf     → stow hypr → ~/.config/hypr/hyprland.conf
  alacritty/.config/alacritty/alacritty.toml
  nvim/.config/nvim/init.lua
  tmux/.tmux.conf
  zsh/.zshrc
  ```
- Never suggest `stow -D` (unstow) without warning that it removes symlinks.
- Never suggest editing symlinked files in `~/` — always edit the source inside the repo.

### Shell & Environment
- Default shell is **zsh**. POSIX-compliant — prefer constructs that work across distros without modification.
- No inline secrets or tokens in `.zshrc` — use a sourced local file (e.g. `~/.config/zsh/conf.d/local.zsh`, gitignored).
- Keep `.zshrc` readable: group by section (PATH, aliases, functions, completions, prompt).
- Never add `source` or `eval` patterns without a comment explaining what it does.

### Secrets & Privacy
- **`.gitignore` is the first file touched** when adding any new package — check it before committing.
- Never commit tokens, API keys, SSH private keys, or machine-specific secrets.
- Files with credentials belong in `~/.config/zsh/conf.d/local.zsh` (gitignored), `~/.aws/credentials` (outside the repo), or a secrets manager — never in dotfiles.
- AWS CLI config (`~/.aws/config`) is safe to version; `~/.aws/credentials` is not.

### Idempotency
- Every install script must be safe to run multiple times.
- Use `command -v <tool> || <install>` guards — never assume a tool is absent or present.
- Scripts must not prompt for input unless absolutely necessary.

---

## Repo Structure

```
~/dotfiles/
├── CLAUDE.md                  ← this file
├── README.md                  ← setup instructions + package list
├── install.sh                 ← idempotent bootstrap script
├── .gitignore
│
├── hypr/                      ← Hyprland window manager
│   └── .config/hypr/
│       ├── hyprland.conf
│       ├── hyprpaper.conf
│       └── keybinds.conf
│
├── alacritty/                 ← Terminal emulator
│   └── .config/alacritty/
│       └── alacritty.toml
│
├── nvim/                      ← Neovim (LazyVim-based)
│   └── .config/nvim/
│       ├── init.lua
│       └── lua/
│
├── tmux/                      ← Terminal multiplexer
│   └── .tmux.conf
│
├── zsh/                       ← Shell config
│   ├── .zshrc
│   └── .config/zsh/
│       └── conf.d/
│
├── git/                       ← Git globals
│   ├── .gitconfig
│   └── .gitignore_global
│
├── aws/                       ← AWS CLI config (no credentials)
│   └── .aws/
│       └── config
│
└── scripts/                   ← Utility scripts (not stowed)
    ├── install-tools.sh
    └── update-all.sh
```

---

## Tool Stack & Defaults

| Tool            | Purpose                              | Config package  |
|-----------------|--------------------------------------|-----------------|
| Hyprland        | Wayland compositor / window manager  | `hypr/`         |
| Alacritty       | GPU-accelerated terminal             | `alacritty/`    |
| tmux            | Terminal multiplexer                 | `tmux/`         |
| Neovim          | Editor (LazyVim starter)             | `nvim/`         |
| zsh + starship  | Shell + prompt                       | `zsh/`          |
| GNU Stow        | Symlink manager                      | —               |
| fzf             | Fuzzy finder (shell + vim)           | `zsh/`          |
| ripgrep         | Fast grep (used by Neovim/fzf)       | —               |
| bat             | `cat` with syntax highlighting       | `zsh/` (alias)  |
| yazi            | Terminal file manager                | `zsh/` (alias)  |
| AWS CLI v2      | AWS access                           | `aws/`          |
| Terraform       | IaC (shared infra)                   | `zsh/` (PATH)   |
| tflint          | Terraform linter                     | —               |
| tfsec           | Terraform security scanner           | —               |
| infracost       | Cloud cost estimation                | —               |

---

## Neovim Conventions

This setup uses **Neovim 0.12's built-in `vim.pack.add`** — not LazyVim or any external plugin manager.

- Add plugins via `vim.pack.add { "https://github.com/author/plugin" }` in `init.lua`.
- Vimscript-only plugins (no Lua `require`) must be explicitly loaded with `vim.cmd('packadd <name>')`.
- All config lives in a single `init.lua` — no `lua/plugins/` subdirectory.
- Plugin lock file: `nvim-pack-lock.json` (auto-updated on first run).

---

## Hyprland Conventions

- Keybinds live in `hyprland.conf` under a clearly commented `# KEYBINDS` section or in a separate `keybinds.conf` (sourced from main config).
- Monitor config is machine-specific — use a `monitors.conf` (gitignored or with a `.example` version committed).
- Startup apps (`exec-once`) must be commented with their purpose.
- Wallpaper is managed via `hyprpaper` — config in `hyprpaper.conf`.

---

## install.sh Conventions

The bootstrap script must follow this order:
1. Check OS (CachyOS/Arch-based assumed; warn if not).
2. Install system packages via `pacman` / `paru` (with `--noconfirm` flag).
3. Install language runtimes (Node.js via `nvm`, etc.).
4. Install cloud tools (AWS CLI, Terraform, tflint, tfsec, infracost).
5. Run `stow` for all packages.
6. Post-install messages: what to do manually (e.g., set zsh as default shell, configure AWS SSO).

Always print a `[OK]`, `[SKIP]`, or `[ERROR]` prefix for each step.

---

## Git Conventions (for this repo)

- Commit messages: `<package>: <what changed>` — e.g., `nvim: add terraform-ls to Mason config`
- One logical change per commit — don't bundle Hyprland + Neovim changes in one commit.
- Tag stable snapshots: `v<year>.<month>` (e.g., `v2026.05`) so you can roll back a full environment.
- The `README.md` must always reflect the current state — update it in the same commit as the config change.

---

## What Claude Should NOT Do

- Do not suggest GUI tools or settings apps — everything is file-based.
- Do not suggest AUR helpers other than `paru` unless explicitly asked.
- Do not add aliases that shadow built-in commands without a comment and a way to bypass (e.g., `\ls` to escape an `ls` alias).
- Do not suggest changes that require a display server restart to test without flagging that explicitly.
- Do not commit machine-specific paths (e.g., `/home/jesus/`) — use `$HOME` always.
- Do not touch `~/.aws/credentials` — ever.

---

## Useful Aliases to Maintain

```zsh
# Dotfiles management
alias dotfiles='cd ~/dotfiles'
alias stowit='cd ~/dotfiles && stow */'      # restow everything
alias dots='nvim ~/dotfiles'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias cat='bat --style=plain'                # requires bat

# Cloud
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias awsid='aws sts get-caller-identity'    # quick account check

# Reload shell
alias reload='source ~/.zshrc'
```

---

*Last updated: 2026-06 — Jesus Plasencia*
