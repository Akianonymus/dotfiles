local config = {
  options = {
    diagnostics = "nvim_lsp",
    offsets = { { filetype = "neo-tree", text = "File Explorer", text_align = "center" } },
    show_close_icon = false,
    max_name_length = 20,
    max_prefix_length = 13,
    tab_size = 20,
    show_buffer_close_icons = true,
    themable = true,
    color_icons = true,
    separator_style = "slope",
  },
}

return function()
  require("bufferline").setup(config)
end
