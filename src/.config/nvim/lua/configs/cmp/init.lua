return function()
  local lsp_icons = require("icons").lsp
  local luasnip = require("luasnip")

  local cmp = require("cmp")

  -- setup cmp for autopairs
  local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  if ok then
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end

  require("autocmds").cmp()

  local config = {
    completion = {
      completeopt = "menu,menuone,noselect",
      keyword_length = 0,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-Space>"] = cmp.mapping(function(fallback)
        cmp.complete()
        if cmp.visible_docs() then
          cmp.close_docs()
        else
          cmp.open_docs()
        end
      end),
      ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      ["<C-m>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "cmp-tw2css" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "async_path" },
    }),
    formatting = {
      format = function(_, item)
        if lsp_icons[item.kind] then
          item.kind = lsp_icons[item.kind] .. item.kind
        end
        item.abbr = string.sub(item.abbr, 1, 30)
        -- item.menu = ""
        return item
      end,
    },
    -- experimental = {
    --   ghost_text = {
    --     hl_group = "Comment",
    --   },
    -- },
  }
  cmp.setup(config)
end
