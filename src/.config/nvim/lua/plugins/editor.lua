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
    version = false,
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = require("configs.neotree"),
    init = function()
      require("mappings").neotree()
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPost",
    config = require("configs.colorizer"),
  },
  {
    "MagicDuck/grug-far.nvim",
    init = function()
      require("autocmds").grug_far()
      require("mappings").grug_far()
      require("commands").grug_far()
    end,
    config = function()
      require("grug-far").setup({
        debounceMs = 500,
        minSearchChars = 2,
        maxSearchMatches = 2000,
        normalModeSearch = true,
        engines = {
          ripgrep = {
            path = "rg",
            showReplaceDiff = true,
            placeholders = {
              enabled = true,
              search = "",
              replacement = "",
              replacement_lua = "",
              filesFilter = "",
              flags = "e.g. -.(--hidden) --ignore-case (-i) --replace= (empty replace) --multiline (-U)",
              paths = "e.g. /foo/bar   ../   ./hello\\ world/   ./src/foo.lua   ~/.config",
            },
          },
        },
        windowCreationCommand = "vsplit",
        disableBufferLineNumbers = true,
        helpLine = { enabled = true },
        keymaps = {
          replace = { n = "<localleader>M" },
          qflist = { n = "<localleader>q" },
          syncLocations = { n = "<localleader>R" },
          syncLine = { n = "<localleader>r" },
          close = { n = "<localleader>c" },
          historyOpen = { n = "<localleader>t" },
          historyAdd = { n = "<localleader>a" },
          refresh = { n = "<localleader>f" },
          openLocation = { n = "<localleader>o" },
          openNextLocation = { n = "<down>" },
          openPrevLocation = { n = "<up>" },
          gotoLocation = { n = "<enter>" },
          pickHistoryEntry = { n = "<enter>" },
          abort = { n = "<localleader>b" },
          help = { n = "g?" },
          toggleShowCommand = { n = "<localleader>p" },
          swapEngine = { n = "" },
          previewLocation = { n = "" },
          swapReplacementInterpreter = { n = "" },
          applyNext = { n = "<localleader>j" },
          applyPrev = { n = "<localleader>k" },
        },
        history = { maxHistoryLines = 500 },
        instanceName = nil,
      })
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
        default_file_explorer = false,
        columns = { "icon", "size" },
      })
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = { show_help = "<f1>" },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = { providers = { "lsp" } },
        min_count_to_highlight = 2,
      })

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
  -- todo
  -- wait for this to be resolved
  -- https://github.com/chrisgrieser/nvim-rip-substitute/issues/6
  -- {
  -- "chrisgrieser/nvim-rip-substitute",
  -- cmd = "RipSubstitute",
  -- keys = {
  --   {
  --     "<leader>fs",
  --     function()
  --       require("rip-substitute").sub()
  --     end,
  --     mode = { "n", "x" },
  --     desc = " rip substitute",
  --   },
  -- },
  -- },
}
