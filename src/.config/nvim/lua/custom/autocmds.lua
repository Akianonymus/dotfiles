local autocmd = vim.api.nvim_create_autocmd
local M = {}

-- non plugin autocmds
function M.aki()
  autocmd("FileType", {
    pattern = "qf",
    callback = function()
      vim.keymap.set("", "q", "<cmd>:close<cr>", { silent = true, buffer = 0 })
    end,
  })

  -- Create directory if missing: https://github.com/jghauser/mkdir.nvim
  autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      require("custom.utils").create_dirs()
    end,
  })

  autocmd("VimLeavePre", { command = [[silent! FidgetClose]] })
end

function M.cmp()
  autocmd("FileType", {
    pattern = "go",
    callback = function()
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.setup.filetype({ "go" }, {
          -- gopls preselects items which I don't like.
          preselect = cmp.PreselectMode.None,
          sorting = {
            -- IMO these comparator settings work better with gopls.
            comparators = {
              cmp.config.compare.length,
              cmp.config.compare.locality,
              cmp.config.compare.sort_text,
            },
          },
        })
      else
        vim.notify("Nvim CMP not loaded", "Error")
      end
    end,
    once = true,
  })
end

function M.fzf_lua()
  autocmd("VimResized", { buffer = 0, command = 'lua require("fzf-lua").redraw()' })
end

function M.lsp_autosave_format(bufnr)
  autocmd({ "BufWritePre" }, {
    buffer = bufnr,
    callback = function()
      if vim.g.vim_version > 7 then
        vim.lsp.buf.format()
      else
        vim.lsp.buf.formatting {}
      end
    end,
  })
end

function M.nvim_go()
  autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.keymap.set("", "<leader>fm", "<cmd>GoFormat<cr>", { silent = true, buffer = 0 })
    end,
  })
end

function M.treesitter()
  autocmd({ "FileType" }, {
    callback = function()
      local char = vim.fn.wordcount()["chars"]
      -- manually disable/enable treesitter after a buffer is created
      if char < 500000 then
        vim.cmd [[silent! TSBufEnable highlight]]
        vim.cmd [[silent! TSBufEnable indent]]
        vim.cmd [[silent! TSBufEnable matchup]]
      else
        vim.cmd [[silent! TSBufDisable highlight]]
        vim.cmd [[silent! TSBufDisable indent]]
        vim.cmd [[silent! TSBufDisable matchup]]
      end
    end,
  })
end

return M
