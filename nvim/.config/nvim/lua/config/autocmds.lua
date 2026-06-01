-- LazyVim handles yank highlight (TextYankPost) and other autocmds.
-- Add project-specific autocmds here only when needed.

-- LazyVim re-enables spell for markdown/gitcommit; override that.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
