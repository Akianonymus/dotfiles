local M = {}

function M.bufferline()
  require "custom.plugins.bufferline"
end

function M.cmp()
  require "custom.plugins.cmp_cmdline"
end

function M.colorizer()
  return {
    filetypes = { "*", "!cmp_menu" },
    user_default_options = {
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = true, -- #0xAARRGGBA hex codes
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      -- Available modes: foreground, background
      mode = "background", -- Set the display mode.
      tailwind = false,
      sass = { enable = true },
    },
    buftypes = { "*", "!terminal", "!prompt", "!popup" },
  }
end

function M.fzf_lua()
  require("fzf-lua").setup {
    fzf_args = "--pointer=' ' --no-hscroll --cycle",
    -- https://github.com/ibhagwan/fzf-lua/issues/493
    fzf_colors = { ["bg+"] = { "bg", "Visual" }, ["gutter"] = { "bg", "Normal" } },
    global_resume = true, -- enable global `resume`?
    global_resume_query = true, -- include typed query in `resume`?
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
      },
      hl = { cursor = "MoreMsg", cursorline = "Visual", title = "TelescopePreviewTitle" },
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
    grep = {
      prompt = "   ",
      rg_opts = " --hidden --line-number --no-heading --color=never --smart-case " .. "-g '!{.git,node_modules}/*'",
      no_header_i = true, -- hide interactive header?
    },
  }
end

function M.lspconfig()
  require "custom.plugins.lspconfig"
end

function M.lsp_signature()
  require("lsp_signature").setup {
    bind = false,
    handler_opts = {
      border = "rounded",
    },
    max_width = 80,
    max_height = 4,
    -- doc_lines = 4,
    floating_window = true,

    floating_window_above_cur_line = true,
    fix_pos = false,
    always_trigger = false,
    zindex = 40,
    timer_interval = 100,
  }
end

function M.null_ls()
  require "custom.plugins.null-ls"
end

function M.nvim_go()
  require("go").setup {
    -- notify: use nvim-notify
    notify = true,
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = "virtual_text",
    -- formatter: goimports, gofmt, gofumpt
    formatter = "gofumpt",
    -- maintain cursor position after formatting loaded buffer
    maintain_cursor_pos = true,
  }
  require("custom.autocmds").nvim_go()
end

function M.nvimtree()
  return {
    filters = { exclude = {} },
    view = { hide_root_folder = false, adaptive_size = false },
    renderer = { indent_markers = { enable = true }, icons = { show = { folder_arrow = false } } },
  }
end

function M.persisted()
  require("persisted").setup {
    -- autoload = true, -- automatically load the session for the cwd on Neovim startup
    allowed_dirs = { "~" },
    -- https://github.com/rmagatti/auto-session/issues/64#issuecomment-1111409078
    before_save = function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config_ = vim.api.nvim_win_get_config(win)
        if config_.relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end
      vim.cmd ":silent! NvimTreeClose"
      vim.cmd ":silent! Neotree close"
    end,
  }
end

function M.telescope()
  return {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
      file_ignore_patterns = { "node_modules/", ".git/" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    extension_list = { "fzf", "notify", "persisted", "neoclip" },
  }
end

function M.toggleterm()
  require("toggleterm").setup {
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        local height = vim.api.nvim_win_get_height(0)
        return (height < 10 and height) or (height * 0.8)
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    -- i basically wanted to disable the mapping so lets use a russian alphabet
    open_mapping = [[д]],
    direction = "horizontal",
  }
end

return M
