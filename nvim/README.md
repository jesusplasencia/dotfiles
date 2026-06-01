# nvim

Neovim configuration based on [LazyVim](https://www.lazyvim.org/).

## What's included

| Feature | How it works |
|---|---|
| Clipboard yank | `clipboard = "unnamedplus"` — LazyVim default |
| Yank highlight | `TextYankPost` autocmd — LazyVim default |
| Hybrid line numbers | `number + relativenumber` — LazyVim default |
| 80-char column bar | `colorcolumn = "80"` — `lua/config/options.lua` |
| Colorscheme | tokyonight — `lua/plugins/colorscheme.lua` |

## Prerequisites

- **Neovim ≥ 0.9** — `yay -S neovim`
- **git** — required by lazy.nvim to fetch plugins
- **A Nerd Font** — for icons (e.g. JetBrainsMono Nerd Font, already set in alacritty config)
- **ripgrep** — `yay -S ripgrep` (used by LazyVim's fuzzy search)
- **lazygit** — `yay -S lazygit` (used by LazyVim's git UI, optional)

## Stow setup

```bash
cd ~/dotfiles
stow nvim
```

This creates the symlink `~/.config/nvim → ~/dotfiles/nvim/.config/nvim`.

## First launch

Open `nvim` and lazy.nvim will auto-install all plugins. This takes ~30–60 seconds on first run.
You will see a progress UI. Once done, restart nvim.

```bash
nvim
# wait for plugin install to complete, then :q and reopen
```

## Verify everything works

Open nvim on any file and run these checks:

```vim
:set number?          " → number
:set relativenumber?  " → relativenumber
:set colorcolumn?     " → colorcolumn=80
:set clipboard?       " → clipboard=unnamedplus
```

**Test yank highlight:** In normal mode, press `yy` — the current line should flash briefly.

**Test clipboard:** Yank a line with `yy`, then paste outside nvim (e.g. in a browser address bar).

## Add more plugins

Drop a new file in `lua/plugins/` and return a lazy plugin spec:

```lua
-- lua/plugins/example.lua
return {
  { "author/plugin-name", opts = {} },
}
```

Never modify `init.lua` for plugin additions — that file is strictly the bootstrap.

## Machine-specific notes

- `lazy-lock.json` is gitignored — it is regenerated automatically on first launch.
- LSP servers are managed via Mason (`:Mason`). Install `terraform-ls`, `yaml-language-server`, etc. as needed.
