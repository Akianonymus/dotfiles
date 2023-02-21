local M = {}

function M.nvim_go()
  require("go").setup({
    -- notify: use nvim-notify
    notify = true,
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = "virtual_text",
    -- formatter: goimports, gofmt, gofumpt
    formatter = "gofumpt",
    -- maintain cursor position after formatting loaded buffer
    maintain_cursor_pos = true,
  })
  require("autocmds").nvim_go()
end

function M.persisted()
  require("persisted").setup({
    branch_separator = "_",
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
      vim.cmd(":silent! NvimTreeClose")
      vim.cmd(":silent! Neotree close")
    end,
  })
end

return M
