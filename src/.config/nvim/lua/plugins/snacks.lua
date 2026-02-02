return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024,
        line_length = 1000,
        setup = function(ctx)
          if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd([[NoMatchParen]])
          end
          vim.opt_local.foldmethod = "manual"
          vim.opt_local.statuscolumn = ""
          vim.opt_local.conceallevel = 0
          vim.b.completion = false
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ctx.buf) then
              vim.bo[ctx.buf].syntax = ctx.ft
            end
          end)
        end,
      },
    },
    keys = {
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.git.browse() end, desc = "Git Browse" },
      { "<leader>gf", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>gF", function() Snacks.lazygit.log_file() end, desc = "Lazygit Log Current File" },
      { "<leader>gl", function() Snacks.git.log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.git.log_file() end, desc = "Git Log Current File" },
      { "<leader>z",  function() Snacks.zen() end, desc = "Zen Mode" },
      { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    },
  },
}
