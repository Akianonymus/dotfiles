local config = {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "go",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "vim",
  },
  -- autopairs = { enable = true },
  -- context_commentstring = { enable = true },
  highlight = { enable = true, use_languagetree = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  matchup = { enable = true },
}
local configfn = function()
  local setup = function()
    local present, ts_config = pcall(require, "nvim-treesitter.configs")

    if not present then
      return
    end

    ts_config.setup(config)
  end

  -- do not load if filetype not set
  if vim.bo.filetype ~= "" then
    local chars = vim.fn.wordcount()["chars"]
    -- do not load treesitter if file is bigger than 500 kb
    if chars < 500000 then
      -- do not lazy load if less than 100kb
      if chars < 100000 then
        setup()
      else
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.defer_fn(function()
          setup()
          ---@diagnostic disable-next-line: param-type-mismatch
        end, 0)
      end
    end
  end

  require("autocmds").treesitter()
end
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = configfn,
  },
}
