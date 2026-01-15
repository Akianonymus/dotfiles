-- LSP spec: https://microsoft.github.io/language-server-protocol/specification.html#initialize
-- prevent stupid node deprecation warnings
vim.env.NODE_OPTIONS = "--no-deprecation"

-- Diag config
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = "",
    spacing = 1,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  severity_sort = true,
  float = { show_header = true, border = "rounded" },
})
-- diagnostic setup end

-- Global LSP configuration (applies to all servers)
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
  flags = { debounce_text_changes = 200 },
})

-- LspAttach autocmd - handles per-buffer setup (replaces old on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    if not client then
      return
    end

    -- Handle disable_format
    if client.config and client.config.disable_format then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Setup keymaps
    require("mappings").lspconfig(client, buf)
  end,
})

-- Load server configurations
local servers = require("configs.lspconfig.servers")

-- Helper function to filter filetypes
local function filter_filetypes(default_filetypes, exclude_list)
  local filtered = {}
  for _, ft in ipairs(default_filetypes) do
    if not vim.tbl_contains(exclude_list, ft) then
      table.insert(filtered, ft)
    end
  end
  return filtered
end

-- Configure each server
for server_name, conf in pairs(servers) do
  local disable_format = conf.disable_format or false
  local filetypes_exclude = conf.filetypes_exclude
  local server_config = conf.config or {}
  local before_setup = conf.before_lspconfig_setup

  -- Handle config as function
  if type(server_config) == "function" then
    server_config = server_config()
  end

  -- Handle filetypes_exclude
  if filetypes_exclude then
    -- Get default filetypes from nvim-lspconfig if available
    local default_config = vim.lsp.config[server_name] or {}
    local default_filetypes = default_config.filetypes or {}
    server_config.filetypes = filter_filetypes(default_filetypes, filetypes_exclude)
  end

  -- Store disable_format in config for LspAttach to access
  if disable_format then
    server_config.disable_format = true
  end

  -- Apply server-specific configuration
  if next(server_config) ~= nil then
    vim.lsp.config(server_name, server_config)
  end

  -- Call before_lspconfig_setup hook if exists
  if type(before_setup) == "function" then
    before_setup()
  end
end

-- Enable all configured servers
vim.lsp.enable(vim.tbl_keys(servers))
