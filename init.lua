-- Atur leader key di awal, sebelum memuat lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release

    lazypath,

  })
end
vim.opt.rtp:prepend(lazypath)

-- Memuat konfigurasi inti
require("core")

-- Memuat dan setup lazy.nvim dengan plugin di plugins/init.lua
require("lazy").setup("plugins")
