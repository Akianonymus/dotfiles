local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local M = {}

-- non plugin autocmds
function M.aki()
  -- close with	q on certain filetypes
  autocmd("FileType", {
	    -- stylua: ignore
		pattern = { "qf", "help", "man", "notify", "lspinfo", "startuptime", "noice" },
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
  autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
  })

  -- Highlight on yank
  autocmd("TextYankPost", { callback = vim.highlight.on_yank })

  -- https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
  local function is_float(winnr)
    local wincfg = vim.api.nvim_win_get_config(winnr)
    if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
      return true
    end
    return false
  end

  autocmd("BufLeave", {
    pattern = "*",
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      -- at this stage, current buffer is the buffer we leave
      -- but the current window already changed, verify neither
      -- source nor destination are floating windows
      local from_buf = vim.api.nvim_get_current_buf()
      local from_win = vim.fn.bufwinid(from_buf)
      local to_win = vim.api.nvim_get_current_win()
      if not is_float(to_win) and not is_float(from_win) then
        vim.b.__VIEWSTATE = vim.fn.winsaveview()
      end
    end,
  })
  autocmd("BufEnter", {
    pattern = "*",
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      if vim.b.__VIEWSTATE then
        local to_win = vim.api.nvim_get_current_win()
        if not is_float(to_win) then
          vim.fn.winrestview(vim.b.__VIEWSTATE)
        end
        vim.b.__VIEWSTATE = nil
      end
    end,
  })
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

function M.format_on_save(bufnr, name)
  vim.b.autoformat_aki = vim.g.autoformat_aki
  local augroup_name = "LspFormatOnSave" .. bufnr
  -- always remove the existing autocmd
  pcall(vim.api.nvim_del_augroup_by_name, augroup_name)

  autocmd({ "BufWritePre" }, {
    group = augroup(augroup_name, {}),
    buffer = bufnr,
    callback = function()
      if vim.b.autoformat_aki then
        -- require("utils").typescript_format_import()
        vim.lsp.buf.format({ name = name })
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

function M.grug_far()
  autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my-grug-far-custom-keybinds", { clear = true }),
    pattern = { "grug-far" },
    callback = function()
      require("mappings").grug_far_inline()
    end,
  })
end

return M
