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
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
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
    cmd = "FindReplace",
    config = function()
      require("spectre").setup({
        highlight = { search = "DiagnosticVirtualTextWarn" },
        open_cmd = "noswapfile vnew",
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
    cmd = "SearchBox",
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
  {
    "stevearc/oil.nvim",
    init = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon", "size" },
      })
    end,
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      min_count_to_highlight = 2,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](true)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 15,
      ignoredFiletypes = { "neo-tree" },
      minimumBufferNum = 5,
      ignoreSpecialBuftypes = true,
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup({
        debounceMs = 500,
        minSearchChars = 2,
        maxWorkers = 4,
        extraRgArgs = "",
        disableBufferLineNumbers = true,
        maxSearchCharsInTitles = 30,
        keymaps = {
          replace = "<C-enter>",
          qflist = "<C-q>",
          gotoLocation = "<enter>",
          close = "<C-x>",
        },
        resultsSeparatorLineChar = "",
        placeholders = {
          enabled = true,

          search = "ex: foo    foo([a-z0-9]*)    fun\\(",
          replacement = "ex: bar    ${1}_foo    $$MY_ENV_VAR ",
          filesGlob = "ex: *.lua     *.{css,js}    **/docs/*.md",
          flags = "ex: --help --hidden (-.) --ignore-case (-i) --multiline (-U) --fixed-strings (-F)",
        },
      })
    end,
  },
}
