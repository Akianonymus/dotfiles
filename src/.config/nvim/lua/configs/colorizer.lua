local config = {
  filetypes = { "*", "!cmp_menu", cmp_docs = { always_update = true } },
  user_default_options = {
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- #0xAARRGGBA hex codes
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    -- Available modes: foreground, background
    mode = "background", -- Set the display mode.
    -- virtualtext = "",
    tailwind = false,
    sass = { enable = false },
  },
  buftypes = { "*", "!terminal", "!prompt", "!popup" },
}
return function()
  require("colorizer").setup(config)
end
