local config = {
  filetypes = { "*", "!cmp_menu", cmp_docs = { always_update = true } },
  user_default_options = {
    names = true,
    names_custom = nil,
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- #0xAARRGGBA hex codes
    rgb_fn = true,
    hsl_fn = true,
    -- Available modes: foreground, background
    mode = "background", -- Set the display mode.
    -- virtualtext = "",
    tailwind = "normal",
    sass = { enable = false },
  },
  buftypes = { "*", "!terminal", "!prompt", "!popup" },
}
return function()
  require("colorizer").setup(config)
end
