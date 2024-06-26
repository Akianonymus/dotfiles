local servers = {
  --- example ---
  -- ["bashls"] = { config = function or table , disable_format = true or false }
  -- no need to specify config if no changes are required
  bashls = {},
  clangd = {},
  gopls = { disable_format = true },
  pyright = {},
  -- pylsp = {},
  rust_analyzer = {},
  lua_ls = {},
  emmet_ls = {},
  html = { disable_format = true },
  cssls = {},
  cssmodules_ls = {},
  tsserver = {},
  volar = {},
  tailwindcss = {},
  jdtls = {},
  phpactor = {},
}

servers.tsserver = {
  config = {
    init_options = {
      plugins = {
        { name = "@vue/typescript-plugin", location = "", languages = { "javascript", "typescript", "vue" } },
      },
    },
    filetypes = { "javascript", "typescript", "vue" },
  },
}

servers.tailwindcss = { filetypes_exclude = { "javascript", "typescript" } }

servers.cssmodules_ls = {
  capabilities = { definitionProvider = false },
  filetypes_exclude = { "javascript", "typescript" },
}

servers.emmet_ls = { config = { filetypes = { "javascriptreact", "typescriptreact" } } }

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

return servers
