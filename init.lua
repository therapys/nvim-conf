-- init.lua (at project root)

-- 0) Leader & globals MUST be first so plugins see the right leader
require("vars")

-- 1) Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2) Core editor options & basic (non-plugin) keymaps
require("opts")
require("keys")

-- 3) Load plugins from lua/plugins/init.lua
require("lazy").setup("plugins", {
  ui = { border = "rounded" },
  change_detection = { notify = false },
})


