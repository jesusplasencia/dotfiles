-- LazyVim sets sane defaults. Add personal keymaps here only when needed.

vim.keymap.set("n", "<leader>H", function()
  Snacks.dashboard.open()
end, { desc = "Home Dashboard" })
