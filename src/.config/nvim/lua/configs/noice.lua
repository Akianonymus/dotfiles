local config = {
  -- https://github.com/neovim/nvim-lspconfig/issues/1931#issuecomment-2138428768
  routes = { { filter = { event = "notify", find = "No information available" }, opts = { skip = true } } },
  views = { mini = { win_options = { winhighlight = { Normal = "Normal" } } } },
  lsp = {
    signature = { enabled = false },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["cmp.entry.get_documentation"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  popupmenu = { backend = "cmp" },
  presets = { bottom_search = true, command_palette = true },
}

return function()
  require("noice").setup(config)
end
