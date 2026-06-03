# zsh

POSIX-compliant interactive shell configuration with a modular `$ZDOTDIR` layout, designed to replicate cleanly across Arch Linux, Fedora, Ubuntu, and macOS.

## What's included

- `$ZDOTDIR`-based layout — all config under `~/.config/zsh/`, nothing scattered in `$HOME`
- Modular `conf.d/` structure — one file per concern, easy to override per machine
- Syntax highlighting and autosuggestions via manually cloned plugins (no plugin manager)
- Arrow-key tab completion with case-insensitive matching
- Starship prompt (auto-detected, graceful no-op if absent)
- Full alias set for cloud/IaC work (AWS, Terraform) and daily navigation
- Machine-local overrides via `conf.d/local.zsh` (gitignored, never committed)

## Directory layout

```
zsh/
├── .zshenv                        → ~/.zshenv          sets ZDOTDIR, always sourced
└── .config/zsh/
    ├── .zshrc                     → ~/.config/zsh/.zshrc   main entry point
    └── conf.d/
        ├── path.zsh               PATH and PNPM_HOME
        ├── aliases.zsh            all aliases and helper functions
        ├── completion.zsh         compinit + zstyle menu config
        ├── prompt.zsh             starship initialisation
        └── local.zsh              ← gitignored, create this per machine
```

Plugins live at `~/.config/zsh/plugins/` (gitignored):

```
~/.config/zsh/plugins/
├── zsh-autosuggestions/
└── zsh-syntax-highlighting/
```

## Prerequisites

| Dependency | Arch               | Fedora                 | macOS                   |
|------------|--------------------|------------------------|-------------------------|
|zsh         | `paru -S zsh`      | `dnf install zsh`      | pre-installed           |
|starship    | `paru -S starship` | `dnf install starship` | `brew install starship` |
|bat         | `paru -S bat`      | `dnf install bat`      | `brew install bat`      |
|git         | pre-installed      | pre-installed          | pre-installed           |

## Stow setup

```bash
cd ~/dotfiles
stow zsh
```

Creates these symlinks:

```
~/.zshenv                        → ~/dotfiles/zsh/.zshenv
~/.config/zsh/.zshrc             → ~/dotfiles/zsh/.config/zsh/.zshrc
~/.config/zsh/conf.d/aliases.zsh → ~/dotfiles/zsh/.config/zsh/conf.d/aliases.zsh
~/.config/zsh/conf.d/...         (all conf.d files linked individually)
```

## Bootstrap plugins

Plugins are cloned once per machine and excluded from the repo:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.config/zsh/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.config/zsh/plugins/zsh-syntax-highlighting
```

`.zshrc` sources both with a file guard — missing plugins are silently skipped.

## Set zsh as default shell

```bash
chsh -s /bin/zsh
# Log out and back in for the change to take effect
```

On macOS, use:

```bash
chsh -s /opt/homebrew/bin/zsh   # if installed via Homebrew
```

## Machine-specific secrets and overrides

Zsh sources every `*.zsh` file in `conf.d/` at startup. Create a `local.zsh` there for anything machine-specific that must not be committed:

```zsh
# ~/.config/zsh/conf.d/local.zsh  ← gitignored, never committed
export AWS_PROFILE=my-profile
export GITHUB_TOKEN=ghp_xxxx
export KUBECONFIG="$HOME/.kube/config"
```

This file is excluded via `zsh/.gitignore`.

## Alias reference

### Dotfiles management
| Alias | Expands to |
|---|---|
| `dotfiles` | `cd ~/dotfiles` |
| `stowit` | `cd ~/dotfiles && stow */` |
| `dots` | `nvim ~/dotfiles` |
| `reload` | `source $ZDOTDIR/.zshrc` |

### Navigation
| Alias | Expands to |
|---|---|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `ll` | `ls -lah --color=auto` |
| `cat` | `bat --style=plain` — use `\cat` to bypass |
| `vim` | `nvim` |

### Cloud / IaC
| Alias / Function | Expands to |
|---|---|
| `tf` | `terraform` |
| `tfp` | `terraform plan` |
| `tfa` | `terraform apply` |
| `tfd` | `terraform destroy` |
| `awsid` | `aws sts get-caller-identity` |
| `awsp <profile>` | sets `AWS_PROFILE` and runs `awsid` to confirm |

## Options set in `.zshrc`

| Option | Effect |
|---|---|
| `AUTO_CD` | Type a directory name to cd into it |
| `HIST_IGNORE_DUPS` | Skip duplicate consecutive history entries |
| `HIST_IGNORE_SPACE` | Skip entries that start with a space |
| `SHARE_HISTORY` | Share history across all open sessions |
| `EXTENDED_HISTORY` | Record timestamp alongside each history entry |
| `INTERACTIVE_COMMENTS` | Allow `#` comments in the interactive shell |

History is stored at `$ZDOTDIR/.zsh_history` (gitignored), with 10,000 lines kept in memory and on disk.

## Cross-platform notes

- The CachyOS system config (`/usr/share/cachyos-zsh-config/cachyos-config.zsh`) is sourced conditionally — it is a no-op on Fedora, Ubuntu, and macOS.
- `$ZDOTDIR` is set in `~/.zshenv`, which zsh always sources regardless of invocation mode. This means the config is active in scripts, SSH sessions, and non-login shells without any extra setup.
- All files use `#!/bin/sh`-compatible syntax where applicable; `.zshrc` and `conf.d/` files use zsh-specific features intentionally.

## Notes

- Always edit source files inside the repo (`~/dotfiles/zsh/`), never the symlinked files under `~/.config/zsh/`.
- To update plugins, `git pull` inside each plugin directory under `~/.config/zsh/plugins/`.
- fzf history search (`Ctrl+R`) is available automatically if `fzf` is installed — no extra config needed in zsh.
