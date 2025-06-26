local servers = {
  bashls = {},
  clangd = {},
  gopls = { disable_format = true },
  pyright = {},
  -- pylsp = {},
  rust_analyzer = {},
  lua_ls = {},
  -- emmet_ls = {},
  emmet_language_server = {},
  html = { disable_format = true },
  cssls = {},
  cssmodules_ls = {},
  -- ts_ls = {},
  vtsls = {},
  volar = {},
  tailwindcss = {},
  -- jdtls = {},
}

-- https://github.com/williamboman/mason-lspconfig.nvim/issues/351#issuecomment-2348642855
servers.volar = {
  config = {
    init_options = {
      vue = { hybridMode = true },
      typescript = {
        tsdk = vim.fn.globpath("$MASON/packages/vue-language-server", "node_modules/typescript/lib/"),
      },
    },
  },
}
-- https://github.com/yioneko/vtsls/issues/148#issuecomment-2119744901
servers.vtsls = {
  config = {
    settings = {
      vtsls = { tsserver = { globalPlugins = {} } },
      typescript = {
        tsserver = { maxTsServerMemory = 4000 },
        updateImportsOnFileMove = "always",
      },
    },
    before_init = function(params, config)
      -- local result = vim
      --   .system({ "npm", "query", "#vue" }, { cwd = params.workspaceFolders[1].name, text = true })
      --   :wait()
      -- if result.stdout ~= "[]" then
      local vuePluginConfig = {
        name = "@vue/typescript-plugin",
        location = vim.fn.globpath("$MASON/packages/vue-language-server", "node_modules/typescript/lib/"),
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }
      table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
      -- end
    end,
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  },
}

-- servers.ts_ls = {
--   config = {
--     init_options = {
--       plugins = {
--         {
--           -- https://github.com/neovim/nvim-lspconfig/issues/1931#issuecomment-2138428768
--           name = "@vue/typescript-plugin",
--           location = require("mason-registry").get_package("vue-language-server"):get_install_path()
--             .. "/node_modules/@vue/language-server",
--           languages = { "vue" },
--         },
--       },
--     },
--     filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
--   },
-- }

servers.tailwindcss = { filetypes_exclude = { "javascript", "typescript" } }

servers.cssmodules_ls = {
  capabilities = { definitionProvider = false },
  filetypes_exclude = { "javascript", "typescript" },
}

servers.emmet_language_server = { config = { filetypes = { "javascriptreact", "typescriptreact", "vue" } } }

-- These below needs some extra stuff done to their default config
servers.clangd = {
  config = { capabilities = { offsetEncoding = { "utf-16" } } },
  disable_format = true,
}

-- lua
servers.lua_ls = {
  config = function()
    local lua_lsp = {
      flags = { debounce_text_changes = 300 },
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          runtime = { version = "LuaJIT" },
          workspace = { maxPreload = 10000, preloadFileSize = 5000 },
          telemetry = { enable = false },
        },
      },
    }

    local neovim_config_dir = vim.fn.resolve(vim.fn.stdpath("config"))
    local neovim_local_dir = vim.fn.resolve(vim.fn.stdpath("data"))
    local cwd = vim.fn.getcwd()
    -- is this file in the config directory?
    -- if neovim_parent_dir == cwd then
    if string.match(cwd, neovim_config_dir) or string.match(cwd, neovim_local_dir) then
      local ok, _ = pcall(require, "neodev")
      if ok then
        lua_lsp.settings.Lua["completion"] = { callSnippet = "Replace" }
      end
    end
    return lua_lsp
  end,
  disable_format = true,
}

-- servers.jdtls = {
--   before_lspconfig_setup = function()
--     -- require("java").setup({
--     --   lombok = { version = "nightly" },
--     --   java_test = { enable = false },
--     --   java_debug_adapter = { enable = false },
--     --   spring_boot_tools = { enable = false },
--     --   jdk = { auto_install = false, version = "21.0.5" },
--     --   notifications = { dap = false },
--     --   verification = {
--     --     invalid_order = true,
--     --     duplicate_setup_calls = true,
--     --     invalid_mason_registry = true,
--     --   },
--     -- })
--   end,
--   config = {
--     -- settings = {
--     --   references = { includeDecompiledSources = true },
--     --   implementationsCodeLens = { enabled = true },
--     --   referenceCodeLens = { enabled = true },
--     --   inlayHints = { parameterNames = { enabled = "all" } },
--     --   signatureHelp = { enabled = true, description = { enabled = true } },
--     --   symbols = { includeSourceMethodDeclarations = true },
--     --   rename = { enabled = true },
--     --   contentProvider = { preferred = "fernflower" },
--     --   sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
--     --   redhat = { telemetry = { enabled = false } },
--     -- },
--     -- single_file_support = true,
--     -- init_options = {
--     --   documentSymbol = { dynamicRegistration = false, hierarchicalDocumentSymbolSupport = true, labelSupport = true },
--     -- },
--   },
-- }

return servers
