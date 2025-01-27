return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    event = "BufWritePre",
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if not vim.b.autoformat_aki then
          return
        end
        return { async = false, timeout = 2000 }
      end,
      format_after_save = nil,
      log_level = vim.log.levels.ERROR,
      notify_no_formatters = false,
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },

        lua = { "stylua" },

        go = { "goimports", "gofmt" },

        rust = { "rustfmt" },

        c = { "clang-format" },
        java = { "clang-format" },
        cpp = { "clang-format" },

        html = { "prettierd" },
        json = { "prettierd" },
        scss = { "prettierd" },
        css = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        vue = { "prettierd" },
      },
    },
  },
}
