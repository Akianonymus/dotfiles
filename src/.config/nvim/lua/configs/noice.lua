local config = {
  -- https://github.com/neovim/nvim-lspconfig/issues/1931#issuecomment-2138428768
  routes = {
    {
      filter = {
        any = {
          { event = "notify", find = "No information available" },
          { event = "msg_show", find = "processTicksAndRejections" },
        },
      },
      opts = { skip = true },
    },
  },
  views = { mini = { win_options = { winhighlight = { Normal = "Normal" } } } },
  lsp = {
    signature = { enabled = false },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },

  presets = { bottom_search = true, command_palette = true },
}

return function()
  require("noice").setup(config)
end
