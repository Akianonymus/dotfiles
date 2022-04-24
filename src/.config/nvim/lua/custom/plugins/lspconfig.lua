local lsp_handlers = function()
   local function lspSymbol(name, icon)
      local hl = "DiagnosticSign" .. name
      vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
   end

   lspSymbol("Error", "")
   lspSymbol("Info", "")
   lspSymbol("Hint", "")
   lspSymbol("Warn", "")

   vim.diagnostic.config {
      virtual_text = {
         prefix = "",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
   }

   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
   })
   vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
   })

   -- suppress error messages from lang servers
   -- vim.notify = function(msg, log_level)
   --    if msg:match "exit code" then
   --       return
   --    end
   --    if log_level == vim.log.levels.ERROR then
   --       vim.api.nvim_err_writeln(msg)
   --    else
   --       vim.api.nvim_echo({ { msg } }, true, {})
   --    end
   -- end
end

local setup_lsp = function()
   local capabilities = vim.lsp.protocol.make_client_capabilities()
   capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
   capabilities.textDocument.completion.completionItem.snippetSupport = true
   capabilities.textDocument.completion.completionItem.preselectSupport = true
   capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
   capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
   capabilities.textDocument.completion.completionItem.deprecatedSupport = true
   capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
   capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
   capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
         "documentation",
         "detail",
         "additionalTextEdits",
      },
   }

   local on_attach = function(client, bufnr)
      local function buf_set_option(...)
         vim.api.nvim_buf_set_option(bufnr, ...)
      end
      if client.name == "html" or client.name == "sumneko_lua" then
         client.resolved_capabilities.document_formatting = false
         client.resolved_capabilities.document_range_formatting = false
      end
      -- Enable completion triggered by <c-x><c-o>
      buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

      require("custom.mappings").lspconfig(client, bufnr)
   end
   local lspconfig = require "lspconfig"

   -- lspservers with default config

   local servers = { "bashls", "clangd", "emmet_ls", "html", "pyright", "rust_analyzer" }

   for _, lsp in ipairs(servers) do
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
      -- if lsp == "clangd" then
      --    capabilities.offsetEncoding = { "utf-16" }
      -- end
      lspconfig[lsp].setup {
         on_attach = on_attach,
         capabilities = capabilities,
         -- root_dir = vim.loop.cwd,
         flags = {
            debounce_text_changes = 200,
         },
      }
   end

   local lua_lsp_config = {
      cmd = { "lua-language-server" },
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
         debounce_text_changes = 300,
      },
      settings = {
         Lua = {
            runtime = {
               version = "LuaJIT",
               -- path = runtime_path,
            },
            workspace = {
               maxPreload = 100000,
               preloadFileSize = 10000,
            },
            telemetry = {
               enable = false,
            },
         },
      },
   }

   local neovim_parent_dir = vim.fn.resolve(vim.fn.stdpath "config")
   local neovim_local_dir = vim.fn.resolve(vim.fn.stdpath "data")
   local cwd = vim.fn.getcwd()
   -- is this file in the config directory?
   -- if neovim_parent_dir == cwd then
   if string.match(cwd, neovim_parent_dir) or string.match(cwd, neovim_local_dir) then
      local ok, lua_dev = pcall(require, "lua-dev")
      if ok then
         local luadev = lua_dev.setup {
            library = {
               vimruntime = true, -- runtime path
               types = true,
               plugins = false,
               -- you can also specify the list of plugins to make available as a workspace library
               -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
            },
            runtime_path = true, -- enable this to get completion in require strings. Slow!
         }
         lua_lsp_config = vim.tbl_deep_extend("force", luadev, lua_lsp_config)
      end
   end
   lspconfig.sumneko_lua.setup(lua_lsp_config)
end

local M = {}
M.setup = function()
   lsp_handlers()
   setup_lsp()
end

M.setup()
