local load_hl = require("base46").load_highlight
load_hl "syntax"
load_hl "treesitter"

local setup = function()
  local present, ts_config = pcall(require, "nvim-treesitter.configs")

  if not present then
    return
  end

  local default = {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "go",
      "javascript",
      "json",
      "lua",
      "markdown",
      "python",
      "vim",
    },
    -- autopairs = { enable = true },
    -- context_commentstring = { enable = true },
    highlight = { enable = true, use_languagetree = true },
    indent = { enable = true },
    matchup = { enable = true },
  }

  ts_config.setup(default)
end

-- do not load treesitter if file is bigger than 500 kb
local chars = vim.fn.wordcount()["chars"]
if chars < 500000 then
  -- do not lazy load if less than 150kb
  if chars < 150000 then
    setup()
  else
    vim.schedule_wrap(function()
      setup()
    end)
  end
end

require("custom.autocmds").treesitter()
