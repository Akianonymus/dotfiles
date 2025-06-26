local formatting = {
  format = function(_, vim_item)
    vim_item.kind = ""
    return vim_item
  end,
}

return function()
  local cmp = require("cmp")
  cmp.setup.cmdline("/", {
    formatting = formatting,
    sources = { { name = "buffer" } },
    mapping = cmp.mapping.preset.cmdline({}),
  })

  cmp.setup.cmdline(":", {
    formatting = formatting,
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    mapping = cmp.mapping.preset.cmdline({}),
  })
end
