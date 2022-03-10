local setup = function()
   local present, ts_config = pcall(require, "nvim-treesitter.configs")

   if not present then
      return
   end

   local default = {
      ensure_installed = {
         "bash",
         "c",
         "cpp",
         "css",
         "javascript",
         "json",
         "lua",
         "markdown",
         "python",
         "vim",
      },
      -- autopairs = { enable = true },
      -- context_commentstring = { enable = true },
      highlight = {
         enable = true,
         use_languagetree = true,
      },
      indent = { enable = true },
      matchup = { enable = true },
   }

   ts_config.setup(default)
end

-- lazy load treesitter always
-- only load if num of lines < 5000
if vim.fn.line "$" < 5000 then
   vim.defer_fn(function()
      setup()
   end, 0)
end
