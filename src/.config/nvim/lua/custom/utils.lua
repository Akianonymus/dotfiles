local M = {}

function M.enable_folding()
   if require("nvim-treesitter.ts_utils").get_node_at_cursor() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
   else
      vim.opt.foldmethod = "indent"
   end
   vim.opt.foldenable = false
end

function M.create_dirs()
   local dir = vim.fn.expand "%:p:h"
   if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
   end
end

function M.search_and_replace()
   -- grab content of " register"
   local content, v_mode = vim.fn.getreg '"', false

   -- restore " register
   vim.fn.setreg('"', vim.fn.getreg "0")

   if content:match "\n" then
      content, v_mode = nil, true
   end

   require("searchbox").replace { confirm = "menu", default_value = content, visual_mode = v_mode }
end
-- M.search_and_replace()
return M
