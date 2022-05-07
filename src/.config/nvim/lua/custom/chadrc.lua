local M = {}

M.options = {
   user = function()
      local opt = vim.opt
      -- local g = vim.g

      opt.tabstop = 4
      opt.undofile = false
   end,

   nvChad = {
      -- update_url = "https://github.com/Akianonymus/NvChad",
      update_url = "https://github.com/NvChad/NvChad",
      update_branch = "main",
   },
}

M.ui = {
   theme = "tokyodark", -- default theme
}

M.plugins = {
   options = {
      statusline = {
         style = "arrow",
      },
   },
   remove = {
      "neovim/nvim-lspconfig",
      "williamboman/nvim-lsp-installer",
   },
   user = "custom.plugins",
}

M.plugins.override = {
   ["max397574/better-escape.nvim"] = {
      mapping = { "jk", "JK", "Jk" }, -- a table with mappings to use
   },
   ["akinsho/bufferline.nvim"] = { options = { custom_areas = false } },
   ["windwp/nvim-autopairs"] = { check_ts = true },
   ["feline-nvim/feline.nvim"] = {
      lsp_icon = {
         provider = function()
            return next(vim.lsp.buf_get_clients()) and "  LSP" or ""
         end,
      },
   },
   ["neovim/nvim-lspconfig"] = "custom.plugins.lspconfig",
   ["nvim-treesitter/nvim-treesitter"] = "custom.plugins.treesitter",
   ["nvim-telescope/telescope.nvim"] = {
      defaults = {
         file_ignore_patterns = { "node_modules/", ".git/" },
         history = {
            path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
            limit = 100,
         },
      },
      extensions = {
         fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
         },
      },
   },
   ["NvChad/nvim-colorizer.lua"] = {
      user_default_options = {
         names = false, -- "Name" codes like Blue
         RRGGBBAA = true, -- #RRGGBBAA hex codes
         rgb_fn = true, -- CSS rgb() and rgba() functions
         hsl_fn = true, -- CSS hsl() and hsla() functions
         css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
         css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn

         -- Available modes: foreground, background
         mode = "background", -- Set the display mode.
      },
   },
   ["ray-x/lsp_signature.nvim"] = {
      doc_lines = 2,
      floating_window_above_cur_line = true,
      -- floating_window_off_x = 10,
      -- floating_window_off_y = 10,
      fix_pos = false,
   },
   ["kyazdani42/nvim-tree.lua"] = {
      view = {
         hide_root_folder = false,
      },
      renderer = {
         indent_markers = {
            enable = true,
         },
      },
   },
}

M.mappings = { -- terminal related mappings
   misc = function()
      -- local map = require("core.utils").map
      -- vim.keymap.del("n" , "<leader>fa")
   end,
}

M.mappings.plugins = {
   lspconfig = {
      declaration = "gD",
      definition = "gd",
      hover = "K",
      implementation = "gi",
      signature_help = "gk",
      add_workspace_folder = "<leader>wa",
      remove_workspace_folder = "<leader>wr",
      list_workspace_folders = "<leader>wl",
      type_definition = "<leader>D",
      rename = "<leader>re",
      code_action = "<leader>ca",
      references = "gr",
      formatting = "<leader>fm",
      -- diagnostics
      workspace_diagnostics = "<leader>q",
      buffer_diagnostics = "ge",
      goto_prev = "[d",
      goto_next = "]d",
   },
}

return M
