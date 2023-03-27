" Vim Configuration file

" PLUGINS ---------{{{
call plug#begin('~/.vim/plugged')

" Automatic quite bracket completion
" Plug 'jiangmiao/auto-pairs'

Plug 'morhetz/gruvbox'

" Vim airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Language Server Protocol 
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" PLug NerdTree
Plug 'preservim/nerdtree'

" Add icons to NerdTree. make some problems on view
" Plug 'ryanoasis/vim-devicons'

" Plug for css color
Plug 'ap/vim-css-color' 

" Markdown 
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

call plug#end()
"}}}
" INIT ----------{{{
scriptencoding utf-8
set encoding=utf-8
setglobal fileencoding=utf-8
set fillchars=vert:\┃
" Markdown Settings
set conceallevel=2

set number
highlight ColorColumn ctermbg=444
set relativenumber
set title
set history=100
" display all matching whwn we tab complete
set wildmenu
" Search down into subfolder
set path+=**
syntax on 
" Clipboard settings
set clipboard=unnamed
" Avoid compatability errors'
set nocompatible
" We can set fdm to marker, diff, syntax, expr, indent 
set foldmethod=marker
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:list,full
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
"}}}
" TAB Options ------------{{{
" Real programmers don't use TABs but spaces
nnoremap <Tab> >>
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-D>
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
"}}}
" Search Options ---------{{{
" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase
"}}}
" Theme -----------------{{{
colorscheme gruvbox
set background=dark
let g:airline_theme='base16'

" Status line left side.
" set statusline+=\ %F\ %M\ %Y\ %R
 
" Making the background trancparent
highlight Normal ctermbg=none
highlight NonText ctermbg=none
"}}}
"MAP KEYS -------{{{
" We must remap alt key to Esc key in vim
silent! execute "set <M-q>=\<Esc>q"
" Alt+q to quit buffer 
map <M-q> :bd<CR>
" Not working
map <M-1> :b1<CR>
map <M-2> :b2<CR>
map <M-3> :b3<CR>

" Run NERDTree
map <C-o> :NERDTreeToggle<CR>

" Run NERDtree at startup
" autocmd VimEnter * NERDTree

" autocmd InsertEnter * call deoplete#enable() " Lazy load to reduce startup time
map <Leader>t <plug>NERDTreeTabsToggle<CR>
"}}}

" Bash language server
" if executable('bash-language-server')
"     au User lsp_setup call lsp#register_server({
"             \ 'name': 'bash-language-server',
"             \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
"             \ 'allowlist': ['sh'],
"             \})
" endif
