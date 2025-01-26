-- LSP spec: https://microsoft.github.io/language-server-protocol/specification.html#initialize
-- prevent stupid node deprecation warnings
vim.env.NODE_OPTIONS = "--no-deprecation"

-- no need to touch this file
-- only custom/plugins/lspconfig/servers.lua should be modified ideally
local loaded, lspconfig = pcall(require, "lspconfig")

if not loaded then
  return
end

-- todo: move this to a better place
local l, vtsls = pcall(require, "vtsls")
if l then
  require("lspconfig.configs").vtsls = vtsls.lspconfig
end

-- set border to :LspInfo window
require("lspconfig.ui.windows").default_options.border = "rounded"

-- diagnostic setup
local icons = require("icons").diagnostics
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local signs = {
  { name = "DiagnosticSignHint", text = icons.Hint },
  { name = "DiagnosticSignInfo", text = icons.Info },
  { name = "DiagnosticSignWarn", text = icons.Warn },
  { name = "DiagnosticSignError", text = icons.Error },
}
-- set sign highlights to same name as sign
-- i.e. 'DiagnosticWarn' gets highlighted with hl-DiagnosticWarn
for i = 1, #signs do
  signs[i].texthl = signs[i].name
end
-- define all signs at once
vim.fn.sign_define(signs)

-- Diag config
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = "",
    spacing = 1,
    -- format = function(diagnostic)
    -- 	if diagnostic.severity == vim.diagnostic.severity.ERROR then
    -- 		return string.format("%s %s", icons.Error, diagnostic.message)
    -- 	end
    -- 	if diagnostic.severity == vim.diagnostic.severity.WARN then
    -- 		return string.format("%s %s", icons.Warn, diagnostic.message)
    -- 	end
    -- 	return ("%s"):format(diagnostic.message)
    -- end,
  },
  signs = true,
  severity_sort = true,
  float = { show_header = true, border = "rounded" },
})
-- diagnostic setup end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- setup the GLobalAutoFormat command
require("commands").toggle_autoformat_global()

local servers = require("configs.lspconfig.servers")
for server, conf in pairs(servers) do
  local name = server
  local currentlsp = lspconfig[name]
  local disable_format = conf.disable_format or false
  local filetypes_exclude = conf.filetypes_exclude or false
  local config = conf.config or {}
  local final_config = config

  if type(config) == "function" then
    final_config = config()
  end

  if type(final_config) ~= "table" then
    vim.notify("custom/lspconfig.lua: final_config was not a table for " .. name, 3)
    final_config = {}
  end

  if filetypes_exclude then
    local old_filetypes = currentlsp.document_config.default_config.filetypes
    local new_filetypes = {}
    for _, filetype in ipairs(old_filetypes) do
      if not vim.tbl_contains(filetypes_exclude, filetype) then
        table.insert(new_filetypes, filetype)
      end
    end
    final_config.filetypes = new_filetypes
  end

  local default_config = {
    on_attach = function(client, buffer)
      if disable_format then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
      require("mappings").lspconfig(client, buffer)
    end,
    capabilities = capabilities,
    -- root_dir = vim.loop.cwd,
    flags = { debounce_text_changes = 200 },
  }

  final_config = vim.tbl_deep_extend("force", default_config, final_config) or default_config

  if type(conf.before_lspconfig_setup) == "function" then
    conf.before_lspconfig_setup()
  end

  currentlsp.setup(final_config)
end
