return function()
  local config = {
    fzf_args = "--pointer=' ' --no-hscroll --cycle",
    -- https://github.com/ibhagwan/fzf-lua/issues/493
    fzf_colors = { ["bg+"] = { "bg", "Visual" }, ["gutter"] = { "bg", "Normal" } },
    global_resume = true, -- enable global `resume`?
    global_resume_query = true, -- include typed query in `resume`?
    prefix = " aki ",
    hls = { title = "Substitute" },
    winopts = {
      width = 0.90,
      height = 0.75,
      row = 0.40, -- window row position (0=top, 1=bottom)
      -- 'none', 'single', 'double', 'thicc' or 'rounded' (default)
      border = "rounded",
      preview = {
        delay = 50,
        vertical = "down:45%",
        horizontal = "right:50%",
        title_pos = "center",
        wrap = "wrap",
      },
    },
    files = {
      prompt = "   Files ",
      actions = {
        ["default"] = require("fzf-lua.actions").file_edit,
      },
    },
    help_tags = { prompt = "   Help " },
    grep = {
      prompt = "   Word ",
      rg_opts = " --column --hidden --line-number --no-heading --color=never --smart-case "
        .. "-g '!{.git,node_modules}/*'",
      -- no_header_i = true, -- hide interactive header?
      actions = {
        ["default"] = require("fzf-lua.actions").file_edit,
      },
    },
    previewers = {
      builtin = {
        extensions = { ["png"] = { "ueberzug" }, ["jpg"] = { "ueberzug" } },
      },
    },
  }

  require("fzf-lua").setup(config)
end
