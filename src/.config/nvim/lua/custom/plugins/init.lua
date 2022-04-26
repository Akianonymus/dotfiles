local plugin_settings = require("core.utils").load_config().plugins

return {
   {
      "stevearc/dressing.nvim",
      disable = false,
      opt = true,
      setup = function()
         require("core.utils").packer_lazy_load("dressing.nvim", 500)
      end,
   },
   { "kevinhwang91/nvim-bqf", ft = "qf" },
   {
      "folke/trouble.nvim",
      module = "trouble",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
         require("trouble").setup {
            auto_close = true, -- automatically close the list when you have no diagnostics
            use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
         }
      end,
   },
   {
      "jose-elias-alvarez/null-ls.nvim",
      disable = plugin_settings.status.null_ls and true,
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,
   },
   { "folke/lua-dev.nvim", ft = "lua" },
   {
      "nacro90/numb.nvim",
      event = "CmdlineEnter",
      config = function()
         require("numb").setup()
      end,
   },
   {
      "haringsrob/nvim_context_vt",
      opt = true,
      config = function()
         require("nvim_context_vt").setup()
      end,
      setup = function()
         require("core.utils").packer_lazy_load("nvim_context_vt", 1000)
      end,
   },
   -- telescope
   {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "fzf"
      end,
      setup = function()
         require("core.utils").packer_lazy_load("telescope.nvim", 1000)
      end,
   },
   {
      "hrsh7th/cmp-cmdline",
      after = "nvim-cmp",
      config = function()
         local cmp = require "cmp"
         cmp.setup.cmdline("/", {
            sources = {
               { name = "buffer" },
            },
         })
         cmp.setup.cmdline(":", {
            sources = cmp.config.sources({
               { name = "path" },
            }, {
               { name = "cmdline" },
            }),
         })
      end,
      setup = function()
         require("core.utils").packer_lazy_load "nvim-cmp"
      end,
   },
   {
      "ggandor/lightspeed.nvim",
      opt = true,
      config = function()
         require("lightspeed").setup {
            ignore_case = true,
            repeat_ft_with_target_char = true,
         }
      end,
      setup = function()
         require("core.utils").packer_lazy_load "lightspeed.nvim"
      end,
   },
   {
      "VonHeikemen/searchbox.nvim",
      module = "searchbox",
      command = "SearchBox",
      requires = {
         { "MunifTanjim/nui.nvim" },
      },
      setup = function()
         require("custom.mappings").searchbox()
      end,
   },
   {
      "windwp/nvim-spectre",
      module = "spectre",
      command = "FindReplace",
      config = function()
         require("spectre").setup {
            color_devicons = true,
            open_cmd = "new",
            is_insert_mode = true,
         }
      end,
      setup = function()
         vim.cmd 'silent! command FindReplace lua require("spectre").open({})'
      end,
   },
   {
      "anuvyklack/pretty-fold.nvim",
      config = function()
         require("pretty-fold").setup {}
         require("pretty-fold.preview").setup()
      end,
   },
}
