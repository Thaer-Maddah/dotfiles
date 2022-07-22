" ======================================
" File Location: ~/.config/nvim/init.vim
" Binary App: neovim
" ======================================

" call plug#begin('~/.vim/plugged')
call plug#begin('~/.local/share/nvim/plugged')

" Make sure you use single quotes
" Plugins for python autocomplete

Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Automatic quite bracket completion
" Plug 'jiangmiao/auto-pairs'

" Code auto-format plugin
Plug 'sbdchd/neoformat'

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Vim airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Async autocompletion for Vim 8 and Neovim with |timers|.
Plug 'prabirshrestha/asyncomplete.vim'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" Syntastic is a syntax checking plugin for Vim created by Martin Grenfell. 
Plug 'vim-syntastic/syntastic'

" Plugin for support C# codding
Plug 'OmniSharp/omnisharp-vim'

" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
" This plugin higlighting Unity variables
Plug 'dense-analysis/ale'

" Plugin for Unity
Plug 'tpope/vim-dispatch'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}


" Install Python mod... Slow vim when opens py files
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" Install color scheme
Plug 'morhetz/gruvbox'

" PLug NerdTree
Plug 'preservim/nerdtree'

" Add icons to NerdTree 
Plug 'ryanoasis/vim-devicons'

" Plug NerdCommenter
Plug 'preservim/nerdcommenter'

" Plug File manager inside im
Plug 'vifm/vifm.vim'

" Plug for css color
Plug 'ap/vim-css-color' 
" install Vim surround

" fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'


"Use release branch (Recommend) This plugin for Angular
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Serach from Vim
" Plug 'kien/ctrlp.vim'

" Go Language
Plug 'fatih/vim-go'

" LSP 
Plug 'neovim/nvim-lspconfig'

" Lua
Plug 'nvim-lua/completion-nvim'

" Markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

call plug#end()

" Add lua namespace
lua require('nspace')

set t_Co=256
set nobackup
set noswapfile
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
" Search down into subfolders
set path+=**
" Display all matching files when we tab complete
set wildmenu
" save file with sudo privileges 
let g:sudo_askpass='/usr/lib/openssh/gnome-ssh-askpass'
let g:airline_theme='base16'
"
" Initialize plugin system

" Activates file type detection
filetype plugin indent on

" Code highlighting
syntax on

" Leader key
let mapleader = " "

" Markdown Settings 
set conceallevel=2
" Show whitespace
" MUST be inserted BEFORE the colorscheme command
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" au InsertLeave * match ExtraWhitespace /\s\+$/

" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
"set t_Co=256
"colorscheme wombat256mod
"colorscheme torte 	" For CSharp Code Syntax highlighting murphy colorscheme Doesn't work

colorscheme gruvbox 
set background=dark " use dark mode

" Showing line numbers and length
set number 
set relativenumber " show line numbers
" set relativenumber
highlight ColorColumn ctermbg=233

" Useful settings
set history=1000
set undolevels=1000

" Real programmers don't use TABs but spaces
nnoremap <Tab> >>
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-D>
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Stop auto comminting 
" set formatoptions-=cro
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Presistent undo even when we close nvim
set undofile

" Smart Wrapping
set wrap
set textwidth=79
set formatoptions=qrnl

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Keybindng 
nnoremap <leader>nh :noh<CR>

" Alt+q to quit buffer 
map <M-q> :bd <CR>

" Run NERDTree
map <C-o> :NERDTreeToggle<CR>

" Run NERDtree at startup
" autocmd VimEnter * NERDTree

" autocmd InsertEnter * call deoplete#enable() " Lazy load to reduce startup time
map <Leader>t <plug>NERDTreeTabsToggle<CR>

" move nerdtree to the right
let g:NERDTreeWinPos = "left"
" " move to the first buffer
autocmd VimEnter * wincmd p
 
" Close file with NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") 
			\ && b:NERDTree.isTabTree()) | q | endif

" CSharp Settings
inoremap <expr> <Tab> pumvisible() ? '<C-n>' :                                                                                                                  
\ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o>' : '<Tab>'

" Use the stdio version of OmniSharp-roslyn:
let g:OmniSharp_server_stdio = 1

" Use OmniSharp-mono... This option install omini-server to run unity code and
" autocomplete it.
let g:OmniSharp_server_use_mono = 1

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet: 
" https://github.com/neovim/neovim/issues/10996
set completeopt=longest,menuone,preview

" Highlight the completion documentation popup background/foreground the same as
" the completion menu itself, for better readability with highlighted
" documentation.
" set completepopup=highlight:Pmenu,border:off

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

" This is for coc plugin
" let g:ale_completion_enabled = 0

" Update semantic highlighting on BufEnter, InsertLeave and TextChanged
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1
" autocmd FileType cs setlocal omnifunc=OmniSharp#Complete


" Autocomplete for Python
let g:deoplete#enable_at_startup = 0 
autocmd InsertEnter * call deoplete#enable() " Lazy load to reduce startup time
"set completeopt-=preview
let g:python3_host_prog = '/usr/bin/python3'

let g:pymode_python = 'python3'

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

set splitbelow
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Code auto-format
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1


" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Making the background transparent
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" Buffer transission
nnoremap ]b :bn<cr>
nnoremap [b :bp<cr>
nnoremap [B :bfirst<cr>
nnoremap ]B :blast<cr>

lua << EOF
local keymap = vim.keymap.set
for i = 1,9,1
    do
    keymap('n', "<M-"..i..">", ":b"..i.."<CR>")
    end
EOF
