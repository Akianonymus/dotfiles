" Set leader keys
let mapleader = " "
let maplocalleader = " "

" General settings
set clipboard=unnamedplus
set nocursorline

" Indenting
set smarttab
set expandtab
set shiftwidth=2
set smartindent
set shiftround
set tabstop=4
set softtabstop=2

" UI settings
set fillchars=eob:\
set ignorecase
set smartcase
set mouse=a
set splitbelow
set splitright
set termguicolors
set timeoutlen=400
set updatetime=250

" Line wrapping behavior
set whichwrap+=<,>,[,],h,l

" Confirmation dialog
set confirm

" Format options
set formatoptions-=a
set formatoptions-=t
set formatoptions+=c
set formatoptions+=q
set formatoptions-=o
set formatoptions+=r
set formatoptions+=n
set formatoptions+=j
set formatoptions-=2

" Scrolling and visual settings
set scrolloff=2
set sidescrolloff=8
set signcolumn=yes
set spelllang=en
set undolevels=10000
set wildmode=longest:full,full
set winminwidth=5

" Key mappings
" Allow moving through wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
xnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
xnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap <expr> <Down> v:count ? 'j' : 'gj'
xnoremap <expr> <Down> v:count ? 'j' : 'gj'
nnoremap <expr> <Up> v:count ? 'k' : 'gk'
xnoremap <expr> <Up> v:count ? 'k' : 'gk'

" Put without yanking
xnoremap p P

" Silent undo
nnoremap u :silent undo<CR>

" Maintain visual selection after indent
vnoremap < <gv
vnoremap > >gv

" Yank behavior
nnoremap Y y$
xnoremap Y <Esc>y$gv

" Center screen when searching
nnoremap n nzzzv
nnoremap N Nzzzv

" Swap ; with :
nnoremap ; :
xnoremap ; :
onoremap ; :

" H and L for line navigation
nnoremap H 0
xnoremap H 0
onoremap H 0
nnoremap L $
xnoremap L $
onoremap L $

" Clear search highlight with Escape
nnoremap <Esc> :noh<CR><Esc>
inoremap <Esc> <Esc>:noh<CR>

" Window navigation
nnoremap <A-w> <C-w>W
tnoremap <A-w> <C-\><C-n><C-w>W
inoremap <A-w> <C-\><C-n><C-w>W

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Terminal escape
tnoremap <Esc> <C-\><C-n>

" Insert mode navigation
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>

" Select all
nnoremap <C-a> gg0vG$
xnoremap <C-a> gg0vG$

" Save with Ctrl-S
nnoremap <C-s> :silent update<CR>
xnoremap <C-s> :silent update<CR>
inoremap <C-s> <Esc>:silent update<CR>

" Quit mappings
nnoremap <leader><leader>q :qall<CR>
nnoremap <leader>qq :qa<CR>

" Add newlines without insert mode
nnoremap <leader>o :<C-u>call append(line("."), repeat([""], v:count1))<CR>
nnoremap <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

" Move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Buffer commands
nnoremap <leader>b :enew<CR>
" Close current buffer
nnoremap <leader>x :q<CR>

" VS Code integration
nnoremap <leader>ca :call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <leader>cc :call VSCodeNotify('editor.action.codeAction')<CR>
nnoremap <leader>ff :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>fw :call VSCodeNotify('workbench.action.findInFiles')<CR>
nnoremap <leader>/ :call VSCodeNotify('editor.action.commentLine')<CR>
vnoremap <leader>/ :<C-u>call VSCodeNotify('editor.action.commentLine')<CR>
nnoremap gi :call VSCodeNotify('editor.action.goToImplementation')<CR>
nnoremap gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
nnoremap <leader>re :call VSCodeNotify('editor.action.rename')<CR>
nnoremap <leader>fm :call VSCodeNotify('editor.action.formatDocument')<CR>
nnoremap <leader>fs :call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap [e :call VSCodeNotify('editor.action.marker.prev')<CR>
nnoremap ]e :call VSCodeNotify('editor.action.marker.next')<CR>
