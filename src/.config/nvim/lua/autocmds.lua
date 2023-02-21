local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local M = {}

-- non plugin autocmds
function M.aki()
  -- close with	q on certain filetypes
  autocmd("FileType", {
	    -- stylua: ignore
		pattern = { "qf", "help", "man", "notify", "lspinfo", "spectre_panel", "startuptime", "noice" },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  })

  -- Create directory if missing: https://github.com/jghauser/mkdir.nvim
  autocmd("BufWritePre", {
    callback = function()
      require("utils").create_dirs()
    end,
  })

  -- Check if we need to reload the file when it changed
  autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

  -- Highlight on yank
  autocmd("TextYankPost", { callback = vim.highlight.on_yank })
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
        vim.notify("Nvim CMP not loaded", 4)
      end
    end,
    once = true,
  })
end

function M.lsp_autosave_format(bufnr, name)
  local augroup_name = "LspAutoFormatOnSave" .. bufnr
  -- always remove the existing autocmd
  pcall(vim.api.nvim_del_augroup_by_name, augroup_name)

  autocmd({ "BufWritePre" }, {
    group = augroup(augroup_name, {}),
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ name = name })
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
        vim.cmd([[silent! TSBufEnable highlight]])
        vim.cmd([[silent! TSBufEnable indent]])
        vim.cmd([[silent! TSBufEnable matchup]])
      else
        vim.cmd([[silent! TSBufDisable highlight]])
        vim.cmd([[silent! TSBufDisable indent]])
        vim.cmd([[silent! TSBufDisable matchup]])
      end
    end,
  })
end

return M
