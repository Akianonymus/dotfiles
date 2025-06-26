local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    "--depth=10",
    lazypath,
  })
  print("Succesfully downloaded lazy.nvim.")
  require("utils").echo({ { "Succesfully downloaded lazy.nvim.", "healthSuccess" } })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  require("utils").echo({ { "Error downloading lazy.nvim", "Error" } })
  return
end

require("options")
require("autocmds").aki()
require("commands").aki()
require("mappings").aki()

vim.g.current_theme = "kanagawa"
lazy.setup("plugins", {
  defaults = { lazy = true, version = false },
  checker = { enabled = false },
  ui = { border = "rounded" },
  debug = false,
  install = { colorscheme = { vim.g.current_theme } },
  change_detection = { enabled = false },
})
require("mappings").lazy()
