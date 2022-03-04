vim.opt.rtp:append(vim.fn.stdpath "config" .. "/lua/custom/runtime")
vim.opt.pumheight = 30

-- require "custom.profiler"
-- require "custom.plugins"
require("custom.mappings").misc()

vim.defer_fn(function()
   -- Create directory if missing: https://github.com/jghauser/mkdir.nvim
   vim.cmd [[autocmd BufWritePre * lua require('custom.utils').create_dirs()]]

   -- only enable treesitter folding if enabled
   vim.cmd [[autocmd BufWinEnter * lua require('custom.utils').enable_folding()]]

   vim.cmd "hi! Folded guifg=#fff"

   vim.cmd "silent! command Sudowrite lua require('custom.utils').sudo_write()"
end, 0)
