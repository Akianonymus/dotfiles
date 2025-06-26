local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local config = {
  cmd = { "jdtls" },
  settings = {
    java = {
      references = { includeDecompiledSources = true },
      implementationsCodeLens = { enabled = true },
      referenceCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      signatureHelp = { enabled = true, description = { enabled = true } },
      symbols = { includeSourceMethodDeclarations = true },
      rename = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      redhat = { telemetry = { enabled = false } },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },
  single_file_support = true,
  -- init_options = {
  --   extendedClientCapabilities = extendedClientCapabilities,
  -- },
  on_attach = function(client, buffer)
    require("mappings").lspconfig(client, buffer)
  end,
  capabilities = capabilities,
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
  flags = { debounce_text_changes = 200, allow_incremental_sync = true },
}

require("jdtls").start_or_attach(config)
