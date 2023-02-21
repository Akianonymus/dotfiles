return {
  {
    "luisiacc/gruvbox-baby",
    config = function()
      vim.g.gruvbox_baby_background_color = "dark"
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    dependencies = { "folke/lsp-colors.nvim" },
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local default_colors = require("kanagawa.colors").setup()
      local overrides = {
        DiagnosticVirtualTextError = { bg = default_colors.winterRed, fg = default_colors.samuraiRed },
        DiagnosticVirtualTextHint = { bg = "#1a2b32", fg = "#1abc9c" },
        DiagnosticVirtualTextInfo = { bg = "#192b38", fg = "#0db9d7" },
        DiagnosticVirtualTextWarn = { bg = default_colors.winterYellow, fg = default_colors.roninYellow },
        LspInfoBorder = { link = "NormalNC" },
        LspInfoTitle = { fg = "#0db9d7" },
        LspInfoList = { fg = "#0db9d7" },
        LspInfoFiletype = { fg = "green" },
        LspSignatureActiveParameter = { link = "DiagnosticVirtualTextWarn" },
        NormalFloat = { link = "Normal" },
        FloatBorder = { link = "Normal" },
      }
      -- Default options:
      require("kanagawa").setup({
        undercurl = true, -- enable undercurls
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        globalStatus = true, -- adjust window separators highlight for laststatus=3
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {},
        overrides = overrides,
        theme = "default", -- Load "default" theme or the experimental "light" theme
      })

      require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981",
      })
      -- setup must be called before loading
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
