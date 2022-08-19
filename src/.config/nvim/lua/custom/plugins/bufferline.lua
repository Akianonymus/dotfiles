local colors = require("base46").get_theme_tb "base_30"

require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
    offsets = { { filetype = "neo-tree", text = "File Explorer", text_align = "center" } },
    buffer_close_icon = "",
    modified_icon = "",
    close_icon = "",
    show_close_icon = false,
    left_trunc_marker = " ",
    right_trunc_marker = " ",
    max_name_length = 20,
    max_prefix_length = 13,
    tab_size = 20,
    show_buffer_close_icons = true,
    themable = true,
  },
  highlights = { fill = { bg = colors.black2 } },
}

require("custom.mappings").bufferline()
