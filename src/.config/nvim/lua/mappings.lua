local map = function(...)
  vim.keymap.set(...)
end

local M = {}

-- general non plugin mappings
function M.aki()
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

  -- cycle between split windows using Alt+w
  map({ "n", "t", "i" }, "<a-w>", [[<C-\><C-n><C-w>W]], { desc = "Cycle between Windows" })
  -- Move to window using the <ctrl> hjkl keys
  map({ "", "t" }, "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Go to left window" })
  map({ "", "t" }, "<c-j>", [[<cmd>wincmd j<cr>]], { desc = "Go to lower window" })
  map({ "", "t" }, "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Go to upper window" })
  map({ "", "t" }, "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Go to right window" })

  -- escape from terminal mode
  map("t", "<esc>", [[<C-\><C-n>]])
  -- map("t", "jk", [[<C-\><C-n>]])

  -- navigate in insert mode
  map("i", "<C-h>", "<Left>")
  map("i", "<C-l>", "<Right>")
  map("i", "<C-j>", "<Down>")
  map("i", "<C-k>", "<Up>")

  -- select all text in a buffer
  map({ "n", "x" }, "<C-a>", "gg0vG$")

  -- save with c-s in all modes
  map({ "n", "x", "i" }, "<C-s>", "<cmd>:silent update<cr>")

  -- quit
  map("n", "<leader><leader>q", "<cmd>:qall<cr>")
  map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

  -- https://github.com/ibhagwan/nvim-lua/blob/04483090013f02e934c4f6a5497809483ffe3896/lua/keymaps.lua#L216
  -- Map <leader>o & <leader>O to newline without insert mode
  map(
    "n",
    "<leader>o",
    ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
    { silent = true, desc = "Newline below (no insert-mode)" }
  )
  map(
    "n",
    "<leader>O",
    ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
    { silent = true, desc = "Newline above (no insert-mode)" }
  )

  -- Move Lines
  map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
  map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
  map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
  map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
  map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

  map("n", "<leader>b", "<cmd>enew<cr>", { desc = "New Buffer" })

  -- escape from terminal mode
  map("t", "<esc>", [[<C-\><C-n>]])

  -- Resize window using <ctrl> arrow keys
  map("n", "<leader>=", "<C-w>=", { silent = true, desc = "normalize split layout" })
  map(
    "n",
    "<C-Up>",
    "<cmd>lua require'utils'.resize(false, -2)<CR>",
    { silent = true, desc = "horizontal split increase" }
  )
  map(
    "n",
    "<C-Down>",
    "<cmd>lua require'utils'.resize(false,  2)<CR>",
    { silent = true, desc = "horizontal split decrease" }
  )
  map(
    "n",
    "<C-Left>",
    "<cmd>lua require'utils'.resize(true,  -2)<CR>",
    { silent = true, desc = "vertical split decrease" }
  )
  map(
    "n",
    "<C-Right>",
    "<cmd>lua require'utils'.resize(true,   2)<CR>",
    { silent = true, desc = "vertical split increase" }
  )

  -- Clear search, diff update and redraw
  -- taken from runtime/lua/_editor.lua
  map(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" }
  )

  -- highlights under cursor
  if vim.fn.has("nvim-0.9.0") == 1 then
    map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
  end

  -- --convert px to rem, base 13
  -- map("n", "m", [[<cmd>s#\v(\d+\.?\d*)px#\=printf("%g",(str2float(submatch(1))/16))."rem"#g<cr>]])
  -- map("v", "m", [[<cmd>'<,'>s#\v(\d+\.?\d*)px#\=printf("%g",(str2float(submatch(1))/16))."rem"#g<cr>]])
end

M.bufremove = {
  {
    "<leader>x",
    function()
      require("mini.bufremove").delete(0, false)
    end,
    desc = "Delete Buffer",
  },
  {
    "<leader>bd",
    function()
      require("mini.bufremove").delete(0, true)
    end,
    desc = "Delete Buffer (Force)",
  },
}

function M.bufferline()
  map("n", "<tab>", "<cmd>:BufferLineCycleNext<cr>")
  map("n", "<s-tab>", "<cmd>:BufferLineCyclePrev<cr>")
end

function M.comment()
  map("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
  end)
  map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
end

function M.fzflua()
  map("n", "<leader>fr", function()
    require("fzf-lua").resume()
  end, { desc = "Fzf Resume" })

  map("n", "<leader>fb", function()
    require("fzf-lua").buffers()
  end, { desc = "Find buffers" })

  map("n", "<leader>fo", function()
    require("fzf-lua").oldfiles()
  end, { desc = "Find Old Files" })

  map("n", "<leader>ff", function()
    require("fzf-lua").files()
  end, { desc = "Find Files" })

  map("n", "<leader>fw", function()
    require("fzf-lua").live_grep()
  end, { desc = "Find Word [ Folder Wide ]" })

  map("n", "<leader>fh", function()
    require("fzf-lua").help_tags()
  end, { desc = "Help Tags" })

  map("n", "<leader>ch", function()
    require("fzf-lua").command_history()
  end, { desc = "Command History" })
end

function M.grug_far()
  map("n", "<leader>R", function()
    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
  end, { desc = "Find and Replace [ Folder wide ]" })
  map("n", "<leader>s", function()
    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%") } })
  end, { desc = "Find and Replace [ Current File ]" })
  map(
    "x",
    "<leader>s",
    [[:<C-u>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand(" % ") } })<cr>]],
    { desc = "Find and Replace [ Current File ]" }
  )
end

function M.grug_far_inline()
  map("n", "<localleader>i", function()
    require("grug-far").toggle_flags({ "--ignore-case" })
  end, { buffer = true })
  map("n", "<localleader>h", function()
    require("grug-far").toggle_flags({ "--hidden" })
  end, { buffer = true })
  map("n", "<localleader>w", function()
    require("grug-far").toggle_flags({ "--fixed-strings" })
  end, { buffer = true })
  map("n", "<C-i>", function()
    vim.api.nvim_win_set_cursor(vim.fn.bufwinid(0), { 2, 0 })
  end, { buffer = true })
end

M.lazy = function()
  map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })
end

M.lspkeymaps = {
  declaration = "gD",
  definition = "gd",
  hover = "K",
  implementation = "gi",
  signature_help = "gk",
  add_workspace_folder = "<leader>wa",
  remove_workspace_folder = "<leader>wr",
  list_workspace_folders = "<leader>wl",
  type_definition = "<leader>D",
  rename = "<leader>re",
  code_action = "<leader>cc",
  code_action_all = "<leader>ca",
  references = "gr",
  formatting = "<leader>fm",
  formatting_imports = "<leader>fi",
  -- diagnostics
  workspace_diagnostics = "<leader>q",
  buffer_diagnostics = "ge",
  goto_prev_diagnostics = "[d",
  goto_next_diagnostics = "]d",
  goto_prev_error_diagnostics = "[e",
  goto_next_error_diagnostics = "]e",
  document_symbols = "<leader>fs",
}

function M.lspconfig(client, bufnr)
  local m = M.lspkeymaps

  local buf_k = function(mo, k, c)
    map(mo, k, c, { buffer = bufnr })
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_k("n", m.declaration, function()
    vim.lsp.buf.declaration()
  end)

  buf_k("n", m.definition, "<cmd>FzfLua lsp_references<CR>")

  buf_k("n", m.hover, "<cmd>Lspsaga hover_doc ++quiet<CR>")

  buf_k("n", m.implementation, vim.lsp.buf.implementation)

  buf_k("n", m.signature_help, "<cmd>Lspsaga hover_doc<CR>")

  buf_k("n", m.type_definition, vim.lsp.buf.type_definition)

  buf_k("n", m.rename, function()
    vim.lsp.buf.rename()
  end)

  -- buf_k("n", m.code_action, "<cmd>:FzfLua lsp_code_actions<cr>")
  buf_k("n", m.code_action, function()
    ---@diagnostic disable-next-line: missing-fields
    vim.lsp.buf.code_action()
  end)
  buf_k("n", m.code_action_all, function()
    ---@diagnostic disable-next-line: missing-fields
    vim.lsp.buf.code_action({ context = { only = { "source", "refactor", "quickfix" } } })
  end)

  buf_k("n", m.references, "<cmd>FzfLua lsp_references<CR>")

  buf_k("n", m.goto_prev_diagnostics, "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  buf_k("n", m.goto_prev_error_diagnostics, function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)

  buf_k("n", m.goto_next_diagnostics, "<cmd>Lspsaga diagnostic_jump_next<CR>")
  buf_k("n", m.goto_next_error_diagnostics, function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)

  buf_k("n", m.workspace_diagnostics, function()
    if vim.diagnostic.get()[1] then
      vim.cmd("FzfLua diagnostics_workspace")
    else
      vim.notify("No diagnostics found.")
    end
  end)

  buf_k("n", m.buffer_diagnostics, function()
    if vim.diagnostic.get(bufnr)[1] then
      vim.cmd("FzfLua diagnostics_document")
    else
      -- vim.notify("No diagnostics found.")
    end
  end)

  buf_k("n", m.add_workspace_folder, vim.lsp.buf.add_workspace_folder)

  buf_k("n", m.remove_workspace_folder, vim.lsp.buf.remove_workspace_folder)

  buf_k("n", m.list_workspace_folders, function()
    vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)

  buf_k("n", m.document_symbols, "<cmd>:FzfLua lsp_document_symbols<cr>")
end

function M.neotree()
  map({ "n" }, "<C-n>", "<cmd>Neotree toggle<cr>")
end

function M.neogen()
  map({ "n" }, "<Leader>d", function()
    require("neogen").generate()
  end)
  map({ "i" }, "<C-f>", function()
    require("neogen").jump_next()
  end)
  map({ "i" }, "<C-b>", function()
    require("neogen").jump_prev()
  end)
end

-- stylua: ignore
M.noice = {
  { "<S-Enter>", function()  require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
	{ "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" } },
	{ "<c-b>", function() if not require("noice.lsp").scroll( -4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } },
}

function M.toggleterm()
  map({ "n", "i", "t" }, "<a-t>", function()
    require("toggleterm").toggle(0, nil, nil, "horizontal")
  end)
  map({ "n", "i", "t" }, "<a-v>", function()
    require("toggleterm").toggle(0, nil, nil, "vertical")
  end)
  map({ "n", "i", "t" }, "<a-f>", function()
    require("toggleterm").toggle(0, nil, nil, "float")
  end)
end

M.yanky = {
  { "y", mode = { "x", "n" }, "<Plug>(YankyYank)" },
  {
    "<leader>p",
    mode = "n",
    function()
      ---@diagnostic disable-next-line: different-requires
      require("telescope").extensions.yank_history.yank_history({})
    end,
    desc = "Paste from Yanky",
  },
}

function M.vim_visual_multi()
  vim.cmd([[
     let g:VM_maps = {}
     let g:VM_maps["Undo"] = 'u'
     let g:VM_maps["Redo"] = '<C-r>'

     let g:VM_maps['Find Under']         = '<A-n>'
     let g:VM_maps['Find Subword Under'] = '<A-n>'

     function! VM_Start()
       nmap <buffer> n <Plug>(VM-Find-Next)zzzv
       nmap <buffer> N <Plug>(VM-Find-Prev)zzzv
     endfunction
     " todo: improve this
     function! VM_Exit()
       nunmap <buffer> n nzzv
       iunmap <buffer> N nzzv
     endfunction
  ]])
end

return M
