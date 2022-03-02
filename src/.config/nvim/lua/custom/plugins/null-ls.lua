local ok, null_ls = pcall(require, "null-ls")

if not ok then
   return
end

local b = null_ls.builtins
local sources = {

   -- c/c++
   -- b.formatting.clang_format,

   -- python
   -- b.formatting.black,

   -- rust
   b.formatting.rustfmt,

   -- JS html css stuff
   b.formatting.prettierd.with {
      filetypes = { "html", "json", "scss", "css", "javascript", "javascriptreact", "typescript" },
   },
   --    b.diagnostics.eslint.with {
   --       command = "eslint_d",
   --    },

   -- Lua
   b.formatting.stylua,
   b.diagnostics.luacheck.with { extra_args = { "--global vim" } },

   -- Shell
   b.formatting.shfmt,
   b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

local M = {}
M.setup = function()
   null_ls.setup {
      sources = sources,
      on_attach = function(client, bufnr)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
            local m = require("core.utils").load_config().mappings.plugins.lspconfig
            vim.api.nvim_buf_set_keymap(bufnr, "n", m.formatting, "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", {})
            vim.api.nvim_buf_set_keymap(bufnr, "v", m.formatting, "<cmd>lua vim.lsp.buf.range_formatting()<CR>", {})
         end
      end,
   }
end

return M
