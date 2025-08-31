-- lua/config/options.lua

local opt = vim.opt

vim.g.mapleader = " "

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"
vim.opt.ignorecase = true  
vim.opt.smartcase = true   

vim.keymap.set("n", "<Leader>q", ":q<CR>", { noremap = true, silent = true }) -- quit
vim.keymap.set("n", "<Leader>e", ":Ex<CR>", { noremap = true, silent = true }) -- file explorer
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<Esc>", "<Esc>:noh<CR>", { silent = true, desc = "Clear search highlight" })






vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- or ">>", "⚠", etc.
    spacing = 2,
  },
})



