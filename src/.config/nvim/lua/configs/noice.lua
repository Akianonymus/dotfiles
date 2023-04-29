local config = {
  views = {
    mini = { win_options = { winhighlight = { Normal = "Normal" } } },
  },
  lsp = {
    signature = { enabled = false },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["cmp.entry.get_documentation"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  popupmenu = {
    -- backend to use to show regular cmdline completions
    ---@type 'nui'|'cmp'
    backend = "cmp",
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    inc_rename = true,
  },
}

return function()
  require("noice").setup(config)
end
