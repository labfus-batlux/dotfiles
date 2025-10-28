vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins from lua/plugins
require("lazy").setup("plugins", {
  ui = { border = "rounded" },
  change_detection = { notify = false },
})

-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("n", "<leader>qq", ":qa!<CR>", { desc = "Quit all" })
map("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buffer" })

-- Autocmds: adjust theme when macOS appearance changes (on focus)
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local ok, defaults = pcall(vim.fn.system, { 'defaults','read','-g','AppleInterfaceStyle' })
    if vim.fn.has('mac') == 1 then
      local dark = ok and type(defaults) == 'string' and defaults:match('Dark')
      local variant = dark and 'tokyonight-moon' or 'tokyonight-day'
      if pcall(vim.cmd.colorscheme, variant) then end
    end
  end,
})
