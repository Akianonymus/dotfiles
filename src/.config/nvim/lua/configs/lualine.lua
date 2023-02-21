local git_icons = require("icons").git
local diag_icons = require("icons").diagnostics

local function fg(name)
  return function()
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end
local function bg(name)
  return function()
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.background and { bg = string.format("#%06x", hl.background) }
  end
end
local function full_hl(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  local r = {}
  if hl then
    r["bg"] = hl.background and string.format("#%06x", hl.background)
    r["fg"] = hl.foreground and string.format("#%06x", hl.foreground)
  end
  return r
end

local config = {
  options = {
    theme = vim.g.current_theme,
    globalstatus = true,
    disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
    section_separators = { right = "", left = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { "filename", path = 1, symbols = { modified = " ", readonly = "", unnamed = "" } },
    },
    lualine_c = {
      {
        "diagnostics",
        symbols = {
          error = diag_icons.Error,
          warn = diag_icons.Warn,
          info = diag_icons.Info,
          hint = diag_icons.Hint,
        },
      },
    },
    lualine_x = {
			-- stylua: ignore
			{
			  function() return require("noice").api.status.mode.get() end,
			  cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
			  color = fg("Constant") ,
			},
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = fg("Special"),
      },
      { "diff", symbols = git_icons },
    },
    lualine_y = {
      { "searchcount" },
      {
        icon = " LSP",
        function()
          local arr = " "
          local names = ""
          local max = vim.o.columns * 0.2
          for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            if not (server.name == "null-ls") then
              local tmp = names .. " " .. server.name
              if #tmp + #arr <= max - 4 then
                names = tmp
              end
            end
          end
          return names == "" and "" or (arr .. "[" .. names .. " ]")
        end,
        color = full_hl("IncSearch"),
        on_click = function()
          vim.cmd(":LspInfo")
        end,
        padding = 1,
      },
    },
    lualine_z = { { "progress", padding = 1 } },
  },
  extensions = { "neo-tree", "fzf", "toggleterm", "quickfix" },
}
return function()
  require("lualine").setup(config)
end
