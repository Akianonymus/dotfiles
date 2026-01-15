return {
  {
    "NickvanDyke/opencode.nvim",
    lazy = false,
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n" }, "<C-p>", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })

      vim.keymap.set({ "n", "x" }, "<C-k>", function()
        local opencode = require("opencode")
        local bufnr = 0
        local file_name = vim.api.nvim_buf_get_name(bufnr)

        local mode = vim.api.nvim_get_mode().mode
        local content, line_range

        if mode:match("[vV]") then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
          local start = vim.fn.getpos("'<'")
          local end_ = vim.fn.getpos("'>'")
          local start_line = start[2]
          local end_line = end_[2]

          line_range = string.format("%d-%d", start_line, end_line)
          local lines = vim.fn.getregion(start, end_)

          local numbered_lines = {}
          for _, line in ipairs(lines) do
            table.insert(numbered_lines, string.format("%s", line))
          end
          content = table.concat(numbered_lines, "\n")
        else
          local cursor = vim.api.nvim_win_get_cursor(0)
          local line_num = cursor[1]
          line_range = string.format("%d", line_num)

          local line = vim.api.nvim_get_current_line()
          content = string.format("%d:%s", line_num, line)
        end

        local prompt_text = string.format("%s:%s\n%s", file_name, line_range, content)

        opencode.prompt(prompt_text)
      end, { desc = "Send content with line numbers to opencode" })

      vim.defer_fn(function()
        require("opencode").toggle()
        require("opencode").toggle()
      end, 5000)
    end,
  },
}
