return {
  {
    "numToStr/Comment.nvim",
    init = require("mappings").comment,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    --stylua: ignore
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh", "DiffviewFileHistory", },
  },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    config = require("configs.fzf"),
    init = require("mappings").fzflua,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = { "IconPickerNormal", "IconPickerInsert", "IconPickerYank" },
    config = function()
      require("icon-picker").setup({ disable_legacy_commands = true })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = require("configs.neotree"),
    init = require("mappings").neotree,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    config = require("configs.colorizer"),
  },
  {
    "windwp/nvim-spectre",
    command = "FindReplace",
    config = function()
      require("spectre").setup({
        highlight = { search = "DiagnosticVirtualTextWarn" },
        open_cmd = "vertical new",
        is_insert_mode = true,
        line_sep_start = "╭" .. string.rep("─", vim.o.columns),
        line_sep = "╰" .. string.rep("─", vim.o.columns),
        result_padding = "│  ",
        mapping = {
          ["enter_file"] = {
            map = "o",
            cmd = "<Cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "goto current file",
          },
          ["toggle_line"] = {
            map = "t",
            cmd = "<Cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle current item",
          },
          ["change_view_mode"] = {
            map = "m",
            cmd = "<Cmd>lua require('spectre').change_view()<CR>",
            desc = "change result view mode",
          },
          ["toggle_ignore_case"] = {
            map = "I",
            cmd = "<Cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case",
          },
          ["toggle_ignore_hidden"] = {
            map = "H",
            cmd = "<Cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden",
          },
          ["run_current_replace"] = {
            map = "<leader>r",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "replace current line",
          },
        },
      })
    end,
    init = function()
      require("mappings").spectre()
      require("commands").spectre()
    end,
  },
  {
    "VonHeikemen/searchbox.nvim",
    command = "SearchBox",
    dependencies = { "MunifTanjim/nui.nvim" },
    init = require("mappings").searchbox,
    config = function()
      require("searchbox").setup({ popup = { zindex = 100 } })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    init = require("mappings").telescope,
    config = require("configs.telescope"),
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = require("configs.toggleterm"),
    init = require("mappings").toggleterm,
  },
}
