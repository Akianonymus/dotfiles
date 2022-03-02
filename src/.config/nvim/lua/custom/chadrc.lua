local M = {}

M.options = {
   tabstop = 4,
   undofile = false,

   nvChad = {
      -- update_url = "https://github.com/Akianonymus/NvChad",
      update_url = "https://github.com/NvChad/NvChad",
      update_branch = "main",
   },
}

M.ui = {
   theme = "tokyonight", -- default theme
}

M.plugins = {
   -- enable/disable plugins (false for disable)

   status = {
      colorizer = true, -- color RGB, HEX, CSS, NAME color codes
      snippets = true,
   },
   options = {
      statusline = {
         -- truncate statusline on small screens
         shortline = false,
         style = "arrow",
      },
   },
   install = require "custom.plugins",
   default_plugin_remove = {},
}

M.plugins.default_plugin_config_replace = {
   autopairs = { check_ts = true },
   feline = {
      lsp_icon = {
         provider = function()
            return next(vim.lsp.buf_get_clients()) and "  LSP" or ""
         end,
      },
   },
   lspconfig = "custom.plugins.lspconfig",
   nvim_treesitter = "custom.plugins.treesitter",
   telescope = {
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
   nvim_colorizer = {
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
   signature = {
      doc_lines = 2,
      floating_window_above_cur_line = true,
      -- floating_window_off_x = 10,
      -- floating_window_off_y = 10,
      fix_pos = false,
   },
}

M.mappings = { -- terminal related mappings
   terminal = {
      -- get out of terminal mode and hide it
      esc_hide_termmode = { "jjj" },
   },
}
M.mappings.plugins = {

   telescope = {
      find_files = nil,
      find_hiddenfiles = "<leader>ff",
   },
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
