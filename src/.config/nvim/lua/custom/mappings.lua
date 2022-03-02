local config = require("core.utils").load_config()
local maps = config.mappings
local plugin_maps = maps.plugins

local map_wrapper = require("core.utils").map
local map = function(...)
   local keys = select(2, ...)
   if not keys or keys == "" then
      return
   end
   map_wrapper(...)
end

local M = {}

function M.lspconfig(client, bufnr)
   local m = plugin_maps.lspconfig
   local buf_k = function(mo, k, c)
      vim.api.nvim_buf_set_keymap(bufnr, mo, k, c, {})
   end

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   buf_k("n", m.declaration, "<cmd>lua vim.lsp.buf.declaration()<CR>")
   buf_k("n", m.definition, "<cmd>lua vim.lsp.buf.definition()<CR>")
   buf_k("n", m.hover, "<cmd>lua vim.lsp.buf.hover()<CR>")
   buf_k("n", m.implementation, "<cmd>lua vim.lsp.buf.implementation()<CR>")
   buf_k("n", m.signature_help, "<cmd>lua vim.lsp.buf.signature_help()<CR>")
   buf_k("n", m.add_workspace_folder, "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
   buf_k("n", m.remove_workspace_folder, "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
   buf_k("n", m.list_workspace_folders, "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
   buf_k("n", m.type_definition, "<cmd>lua vim.lsp.buf.type_definition()<CR>")
   buf_k("n", m.rename, "<cmd>lua vim.lsp.buf.rename()<CR>")
   buf_k("n", m.code_action, "<cmd>lua vim.lsp.buf.code_action()<CR>")
   -- buf_k("n", m.references, "<cmd>lua vim.lsp.buf.references()<CR>")
   buf_k("n", m.references, "<cmd>lua require('trouble').open('lsp_references') <cr>")
   buf_k("n", m.goto_prev, "<cmd>lua vim.diagnostic.goto_prev()<CR>")
   buf_k("n", m.goto_next, "<cmd>lua vim.diagnostic.goto_next()<CR>")
   buf_k(
      "n",
      m.workspace_diagnostics,
      "<cmd>lua if vim.diagnostic.get()[1] then require('trouble').open('workspace_diagnostics') else vim.notify 'No diagnostics found.' end<cr>"
   )
   buf_k(
      "n",
      m.buffer_diagnostics,
      "<cmd>lua if vim.diagnostic.get()[1] then require('trouble').open('document_diagnostics') else vim.notify 'No diagnostics found.' end<cr>"
   )

   if client.resolved_capabilities.document_formatting then
      buf_k("n", m.formatting, "<cmd>lua vim.lsp.buf.formatting_sync()<CR>")
      buf_k("v", m.formatting, "<cmd>lua vim.lsp.buf.range_formatting()<cr>")
   end
end

function M.searchbox()
   map("n", "<leader>s", "<cmd>lua require('searchbox').replace({confirm = 'menu'})<CR>")
   map(
      "x",
      "<leader>s",
      "\"yy<cmd>lua require('custom.utils').search_and_replace()<CR>"
      -- "<cmd>lua require('custom').search_and_replace()<cr>"
   )
end

function M.misc()
   -- select all text in a buffer
   map("n", "<C-a>", "gg0vG$")
   map("x", "<C-a>", "gg0oG$")
   -- save with c-s in all modes
   map({ "n", "v", "i" }, "<C-s>", "<cmd>:update<cr>")
   map("n", "<leader>fr", "<cmd>:Telescope resume<cr>")
   map("n", "<leader><leader>q", "<cmd>:qall<cr>")
   -- Reselect visual selection after indenting
   map("v", "<", "<gv")
   map("v", ">", ">gv")
   -- do not select the new line on Y
   map("n", "Y", "y$")
   map("x", "Y", "<Esc>y$gv")
   -- Keep matches center screen when cycling with n|N
   map("n", "n", "nzzzv")
   map("n", "N", "Nzzzv")
end

return M
