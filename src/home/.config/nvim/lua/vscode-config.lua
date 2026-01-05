-- options
local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.laststatus = 3
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = false

-- Indenting
opt.smarttab = true -- Use shiftwidths at left margin, tabstops everywhere else
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.shiftround = true -- Always indent/outdent to nearest tabstop
opt.tabstop = 4
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes:3"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

opt.pumheight = 30
opt.undofile = false
opt.swapfile = false

opt.confirm = true
-- borrowed from tjdevries
opt.formatoptions = opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

opt.sessionoptions = "blank,buffers,curdir,localoptions,folds,help,tabpages,winsize,winpos,terminal"
opt.scrolloff = 2 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.spelllang = { "en" }
opt.undolevels = 10000
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

-- Disable some in built plugins completely
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  -- 'matchit',
  --'matchparen',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

local map = function(...)
  vim.keymap.set(...)
end

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
map({ "n", "x" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, silent = true })
map({ "n", "x" }, "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, silent = true })
map({ "n", "x" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, silent = true })
map({ "n", "x" }, "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, silent = true })

-- put without yanking text
-- https://github.com/vim/vim/releases/tag/v8.2.4242
map("x", "p", "P")

map("n", "u", "<cmd>:silent undo<cr>")

-- Reselect visual selection after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- do not select the new line on y
map("n", "Y", "y$")
map("x", "Y", "<Esc>y$gv")
-- Keep matches center screen when cycling with n|N
map("n", "n", "nzzzv", { desc = "Fwd  search '/' or '?'" })
map("n", "N", "Nzzzv", { desc = "Back search '/' or '?'" })

-- swap ; with :
map({ "n", "o", "x" }, ";", ":")

-- use H for start of line and L for end of line
map({ "n", "o", "x" }, "H", "0", { desc = "Start of Line" })
map({ "n", "o", "x" }, "L", "$", { desc = "End of Line" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- select all text in a buffer
map({ "n", "x" }, "<C-a>", "gg0vG$")

-- save with c-s in all modes
map({ "n", "x", "i" }, "<C-s>", "<cmd>:silent update<cr>")

-- escape from terminal mode
map("t", "<esc>", [[<C-\><C-n>]])

-- --convert px to rem, base 13
-- map("n", "m", [[<cmd>s#\v(\d+\.?\d*)px#\=printf("%g",(str2float(submatch(1))/16))."rem"#g<cr>]])
-- map("v", "m", [[<cmd>'<,'>s#\v(\d+\.?\d*)px#\=printf("%g",(str2float(submatch(1))/16))."rem"#g<cr>]])

-- Add newlines without insert mode
map("n", "<leader>o", [[:<C-u>call append(line("."), repeat([''], v:count1))<CR>]], { noremap = true, silent = true })
map("n", "<leader>O", [[:<C-u>call append(line(".")-1, repeat([''], v:count1))<CR>]], { noremap = true, silent = true })

-- Buffer commands------
map("n", "<C-tab>", function()
  require("vscode").action("workbench.action.nextEditor")
end, { noremap = true, silent = true })
map("n", "<C-S-tab>", function()
  require("vscode").action("workbench.action.previousEditor")
end, { noremap = true, silent = true })
map("n", "<leader>b", function()
  require("vscode").action("workbench.action.files.newUntitledFile")
end, { noremap = true, silent = true })
-- Close current buffer
map("n", "<leader>x", function()
  require("vscode").action("workbench.action.closeActiveEditor")
end, { noremap = true, silent = true })

-- VS Code integration

-- open quick fix
map("n", "<leader>ca", function()
  require("vscode").action("editor.action.quickFix")
end, { noremap = true, silent = true })

-- open code action
map("n", "<leader>cc", function()
  require("vscode").action("editor.action.codeAction")
end, { noremap = true, silent = true })

-- search files
map("n", "<leader>ff", function()
  require("vscode").action("workbench.action.quickOpen")
end, { noremap = true, silent = true })

-- search in files
map("n", "<leader>fw", function()
  require("vscode").action("workbench.action.findInFiles")
end, { noremap = true, silent = true })
map("x", "<leader>fw", function()
  local word = vim.fn.expand("<cword>")
  require("vscode").action("workbench.action.findInFiles", { args = { query = word, filesToInclude = "" } })
end, { noremap = true, silent = true })
map("n", "<leader>s", function()
  local word = vim.fn.expand("<cword>")
  local file = vim.fn.expand("%:t")
  require("vscode").action("workbench.action.replaceInFiles", { args = { query = word, filesToInclude = file } })
end, { noremap = true, silent = true, desc = "Find and Replace [ Current File ]" })

-- comment
map("", "<leader>/", function()
  require("vscode").action("editor.action.commentLine")
end, { noremap = true, silent = true })
map("n", "<leader>/", function()
  require("vscode").action("editor.action.commentLine")
end, { noremap = true, silent = true })

map("n", "gi", function()
  require("vscode").action("editor.action.goToImplementation")
end, { noremap = true, silent = true })
map("n", "gd", function()
  require("vscode").action("editor.action.revealDefinition")
end, { noremap = true, silent = true })

-- rename lsp variable
map("n", "<leader>re", function()
  require("vscode").action("editor.action.rename")
end, { noremap = true, silent = true })

-- format document
map("n", "<leader>fm", function()
  require("vscode").action("editor.action.formatDocument")
end, { noremap = true, silent = true })

-- search symbols
map("n", "<leader>fs", function()
  require("vscode").action("workbench.action.gotoSymbol")
end, { noremap = true, silent = true })

-- go to previous diagnostic
map("n", "[d", function()
  require("vscode").action("editor.action.marker.prev")
end, { noremap = true, silent = true })

-- go to next diagnostic
map("n", "]d", function()
  require("vscode").action("editor.action.marker.next")
end, { noremap = true, silent = true })

-- go to previous error
map("n", "[e", function()
  require("vscode").action("next-error.prevInFiles.error")
end, { noremap = true, silent = true })

-- go to next error
map("n", "]e", function()
  require("vscode").action("next-error.nextInFiles.error")
end, { noremap = true, silent = true })
