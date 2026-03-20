local config = {
  filetypes = { "*", "!blink_menu", blink_docs = { always_update = true } },
  buftypes = { "*", "!terminal", "!prompt", "!popup" },
  options = {
    parsers = {
      names = { enable = true },
      hex = {
        rgb = true,
        rrggbb = true,
        rrggbbaa = true,
        aarrggbb = true,
      },
      rgb = { enable = true },
      hsl = { enable = true },
      tailwind = { enable = true },
      sass = { enable = false, parsers = { css = true } },
    },
    display = {
      mode = "background",
    },
  },
}
return function()
  require("colorizer").setup(config)
end
