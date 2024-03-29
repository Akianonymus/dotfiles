local command = vim.api.nvim_create_user_command
local buf_command = vim.api.nvim_buf_create_user_command

local M = {}

-- non plugin commands
function M.aki()
  command("Sudowrite", function()
    require("utils").sudo_write()
  end, { desc = "Write to files using sudo" })
end

function M.bufferline()
  command("BufferLineCloseOthers", function()
    vim.cmd([[:BufferLineCloseLeft
:BufferLineCloseRight]])
  end, { desc = "Close all buffers except current" })
end
function M.spectre()
  command("FindReplace", function()
    require("spectre").open({})
  end, { desc = "Find and Replace [ Folder Wide ]" })
end

function M.toggle_autoformat(buffer)
  buf_command(buffer, "AutoFormat", function()
    vim.b.autoformat_aki = not vim.b.autoformat_aki
    vim.notify("AutoFormat " .. (vim.b.autoformat_aki and "Enabled" or "Disabled") .. " for current buffer.")
  end, { desc = "Toggle auto formatting" })
end

function M.toggle_autoformat_global()
  vim.g.autoformat_aki = true
  command("AutoFormatGlobal", function()
    vim.g.autoformat_aki = not vim.g.autoformat_aki
    vim.b.autoformat_aki = vim.g.autoformat_aki
    vim.notify("AutoFormat " .. (vim.g.autoformat_aki and "Enabled" or "Disabled") .. " Globally")
  end, { desc = "Toggle auto formatting globally" })
end

return M
