# nvim

Minimal Neovim 0.12 configuration. No plugin manager — uses Neovim's built-in `vim.pack.add`
to fetch exactly two plugins from GitHub on first launch.

## What's included

### Editor options

| Option | Value | Effect |
|---|---|---|
| `number` + `relativenumber` | true | Hybrid line numbers |
| `colorcolumn` | `"100"` | Visual guide at 100 chars |
| `termguicolors` | true | True-color terminal support |
| `cursorline` | true | Highlight the current line |
| `scrolloff` | 8 | Keep 8 lines of context when scrolling |
| `signcolumn` | `"yes"` | Reserve the sign column |
| `spell` | false | Spellcheck off |
| `wrap` | false | No line wrapping |
| `clipboard` | `"unnamedplus"` | Shared OS clipboard |

### Plugins

| Plugin | Purpose |
|---|---|
| `rebelot/kanagawa.nvim` | Colorscheme — **dragon** variant (near-black `#181616` bg, vivid warm code colors) |
| `stevearc/oil.nvim` | File explorer — filesystem as a plain buffer, no filtering, shows hidden files |

## Prerequisites

- **Neovim ≥ 0.12** — required for `vim.pack.add` (`paru -S neovim`)
- **git** — used by `vim.pack.add` to clone plugins on first run
- Internet access on first launch

## Stow setup

```bash
cd ~/dotfiles
stow nvim
```

Creates the symlink `~/.config/nvim → ~/dotfiles/nvim/.config/nvim`.

## First launch

Open `nvim` — `vim.pack.add` will clone both plugins automatically. No restart needed.

```bash
nvim
```

On subsequent launches the plugins are already present; startup is instant.

## File explorer (oil.nvim)

| Key | Action |
|---|---|
| `-` | Open oil in the current file's directory |
| `hjkl` / arrows | Navigate |
| `<CR>` | Open file or enter directory |
| `-` (in oil) | Go up one directory |
| `<C-s>` | Save pending changes (rename, delete, etc.) |
| `q` | Close oil |

Hidden files (dotfiles) are visible by default.

## Verify everything works

```vim
:set number?          " → number
:set relativenumber?  " → relativenumber
:set colorcolumn?     " → colorcolumn=100
:set clipboard?       " → clipboard=unnamedplus
:colorscheme          " → kanagawa-dragon
```

Press `-` in normal mode — oil.nvim should open the current directory with all files visible.
