-- Plugins — vim.pack.add clones from GitHub on first run, no-op after that
vim.pack.add {
    "https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/stevearc/oil.nvim"
}

-- Editor
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "100"

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank() end,
})

-- Kanagawa dragon — darkest variant, near-black bg (#181616), vivid warm code colors
require("kanagawa").setup({ background = { dark = "dragon" } })
vim.cmd("colorscheme kanagawa-dragon")

-- oil.nvim — filesystem as a buffer, fully unrestricted, shows hidden files
require("oil").setup({ view_options = { show_hidden = true } })
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
