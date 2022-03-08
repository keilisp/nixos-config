
"    ██▒   █▓ ██▓ ███▄ ▄███▓ ██▀███   ▄████▄
"   ▓██░   █▒▓██▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▒██▀ ▀█
"    ▓██  █▒░▒██▒▓██    ▓██░▓██ ░▄█ ▒▒▓█    ▄
"     ▒██ █░░░██░▒██    ▒██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒
"      ▒▀█░  ░██░▒██▒   ░██▒░██▓ ▒██▒▒ ▓███▀ ░
"      ░ ▐░  ░▓  ░ ▒░   ░  ░░ ▒▓ ░▒▓░░ ░▒ ▒  ░
"      ░ ░░   ▒ ░░  ░      ░  ░▒ ░ ▒░  ░  ▒
"        ░░   ▒ ░░      ░     ░░   ░ ░
"         ░   ░         ░      ░     ░ ░

set nocompatible

set directory=$XDG_CACHE_HOME/vim/swap,~/,/tmp
set backupdir=$XDG_CACHE_HOME/vim/backup,~/,/tmp
set undodir=$XDG_CACHE_HOME/vim/undo,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
set runtimepath+=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
let $MYVIMRC="$XDG_CONFIG_HOME/vim/.vimrc"

" Vundle settings(idk really)
" set the runtime path to include Vundle and initialize
set rtp+=$XDG_CONFIG_HOME/vim/.vim/bundle/Vundle.vim
call vundle#begin("$HOME/.config/vim/.vim/bundle")
" let Vundle manage Vundle, required
Plugin 'dylanaraps/wal.vim'
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'Chiel92/vim-autoformat'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-commentary'
Plugin 'christoomey/vim-system-copy'
Plugin 'kien/ctrlp.vim'
Plugin 'morhetz/gruvbox'
Plugin 'scrooloose/nerdtree'
Plugin 'indentLine.vim'
Plugin 'lilydjwg/colorizer'
Plugin 'powerman/vim-plugin-ruscmd'
Plugin 'airblade/vim-gitgutter'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'raimondi/delimitmate'
Plugin 'easymotion/vim-easymotion'
Plugin 'arcticicestudio/nord-vim'
" Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-repeat'
Plugin 'chriskempson/base16-vim'
Plugin 'altercation/vim-colors-solarized'
" Plugin 'chasinglogic/modus-themes-vim'
" Plugin 'ishan9299/modus-theme-vim'
Plugin 'ishan9299/modus-theme-vim', {'branch': 'stable'}
Plugin 'NLKNguyen/papercolor-theme'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" -- Display
set title                 " Update the title of your window or your terminal
set number                " Display line numbers
set relativenumber        " Show relative line numbers
set ruler                 " Display cursor position
set wrap                  " Wrap lines when they are too long
set tabstop=4			  " Set tab size
set shiftwidth=2
set autoindent
set smartindent
set cindent
set path+=**
set foldmethod=indent
set nofoldenable

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set scrolloff=3           " Display at least 3 lines around you cursor
" (for scrolling)

set guioptions=T          " Enable the toolbar

" -- Search
set ignorecase            " Ignore case when searching
set smartcase             " If there is an uppercase in your search term
" search case sensitive again
set incsearch             " Highlight search results when typing
set hlsearch              " Highlight search results

" -- Beep
set visualbell            " Prevent Vim from beeping
set noerrorbells          " Prevent Vim from beeping

" Backspace behaves as expected
set backspace=indent,eol,start

" Hide buffer (file) instead of abandoning when switching
" to another buffer
set hidden

" Make splist bahave like expected
set splitbelow splitright

" Enable syntax highlighting
syntax enable
" Enable file specific behavior like syntax highlighting and indentation
filetype on
filetype plugin on
filetype indent on

source $XDG_CONFIG_HOME/vim/current-theme.vim

" Powerline
" set rtp+=/usr/share/powerline/bindings
" let g:Powerline_symbols='unicode'
" let g:Powerline_theme='long'
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1
" let g:airline_theme='papercolor'
" let g:airline_theme='gruvbox'

" Use the dark version of gruvbox
" if has ('termguicolors')
  " set termguicolors
" endif
" set background=light

" let g:solarized_termcolors=256
" colorscheme solarized

" let g:gruvbox_contrast_dark='soft'
" colorscheme gruvbox
" colorscheme wal
" colorscheme base16-default-light
" colorscheme modus-operandi
" colorscheme PaperColor

"Disable arrow keys in Normal mode
"no <Up> <Nop>
"no <Down> <Nop>
"no <Left> <Nop>
"no <Right> <Nop>

"Disable arrow keys in Insert mode
"ino <Up> <Nop>
"ino <Down> <Nop>
"ino <Left> <Nop>
"ino <Right> <Nop>

"Using arrows for resizing splits
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" Remap splits navigation to just CTRL + hjkl
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Map Tab for autocomplition
inoremap <silent><expr> <TAB>
	  \ pumvisible() ? "\<C-n>" :
	  \ <SID>check_back_space() ? "\<TAB>" :
	  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Esc -> jj
inoremap jj <Esc>
inoremap оо <Esc>

" CMD height
let cmdheight=1

" Set mapleader to ','
let mapleader=" "

" CtrlP
let g:ctrlp_map = '<leader>c'
let g:ctrlp_show_hidden = 1

let g:neocomplcache_enable_at_startup = 1

" Changing cursor in insert mode
:autocmd InsertEnter,InsertLeave * set cul!
" Autoformat on write
au BufWrite * :Autoformat
" F8 turning autoformat off on local file
nnoremap <F8> :set eventignore=BufWrite<CR>

" Save and Load Sessions
map <F2> :mksession! ~/vim_session <cr>  " Quick write session with F2
map <F3> :source ~/vim_session <cr>      " And load session with F3

" ejs -> html
au BufNewFile,BufRead *.ejs set filetype=html

" html autocomplete
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" Emmet configuration
let g:user_emmet_leader_key=','

" => NERDTree
" Uncomment to autostart the NERDTree
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1

" => Mouse Scrolling
set mouse=nicr

" => Fixes mouse issues using Alacritty terminal
if !has('nvim')
  set ttymouse=sgr
endif

" Open terminal inside Vim
map <Leader>tt :vnew term://bash<CR>

hi Normal guibg=NONE ctermbg=NONE

"AUTOCLOSING BRACKETS
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>

" inoremap {;<CR> {<CR>};<ESC>O
" inoremap { {<CR>}<up><end><CR>


" Make it so that a curly brace automatically inserts an indented line
inoremap {<CR> {<CR>}<Esc>O<BS><Tab>

" LaTeX preview setup
" let g:livepreview_previewer = 'zathura'
" map <Leader>p :LLPStartPreview
" " To prevent conceal in LaTeX files
" let g:tex_conceal = ''
" To prevent conceal in any file
" set conceallevel = 0

" EasyMotion
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-eine)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Replace all --> S
nnoremap S :%s//g<Left><Left>

" Optimize file for audiosplit
nnoremap F :% norm $Bd$0Pa jj

"  Yank and comment out
nnoremap gC :yank \| Commentary<CR>
vnoremap gC :'<,'>yank \| '<,'>Commentary<CR>

