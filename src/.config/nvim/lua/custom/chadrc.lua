local M = {}

M.options = {
  nvChad = {
    -- update_url = "https://github.com/Akianonymus/NvChad",
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "main",
  },
}

M.ui = {
  theme = "tokyodark",
}

M.plugins = require "custom.plugins"

M.mappings = {
  telescope = require("custom.mappings").telescope,
  disabled = require("custom.mappings").disabled,
}

return M
