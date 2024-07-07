return function()
  local config = {
    fzf_args = "--pointer=' ' --no-hscroll --cycle",
    -- https://github.com/ibhagwan/fzf-lua/issues/493
    fzf_colors = { ["bg+"] = { "bg", "Visual" }, ["gutter"] = { "bg", "Normal" } },
    global_resume = true, -- enable global `resume`?
    global_resume_query = true, -- include typed query in `resume`?
    prefix = " aki ",
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
        title_align = "center",
        wrap = "wrap",
      },
      hl = { title = "Substitute" },
      on_create = function()
        local function feedkeys(normal_keys, insert_key)
          if type(normal_keys) ~= "table" then
            normal_keys = { normal_keys }
          end

          for _, key in ipairs(normal_keys) do
            vim.keymap.set("n", key, function()
              vim.api.nvim_chan_send(
                vim.b.terminal_job_id,
                vim.api.nvim_replace_termcodes(insert_key, true, false, true) or ""
              )
            end, { nowait = true, noremap = true, buffer = vim.api.nvim_get_current_buf() })
          end
        end

        feedkeys({ "j", "<c-n>" }, "<c-n>")
        feedkeys({ "k", "<c-p>" }, "<c-p>")
        feedkeys({ "f", "<c-f>" }, "<c-f>")
        feedkeys({ "b", "<c-b>" }, "<c-b>")
        feedkeys({ "q", "<Esc>" }, "<Esc>")
        feedkeys({ "o", "<CR>" }, "<CR>")
      end,
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
      rg_opts = " --hidden --line-number --no-heading --color=never --smart-case " .. "-g '!{.git,node_modules}/*'",
      no_header_i = true, -- hide interactive header?
    },
    previewers = {
      builtin = {
        extensions = {
          ["png"] = { "ueberzug" },
          ["svg"] = { "ueberzug" },
          ["jpg"] = { "ueberzug" },
        },
      },
    },
  }

  require("fzf-lua").setup(config)
end
