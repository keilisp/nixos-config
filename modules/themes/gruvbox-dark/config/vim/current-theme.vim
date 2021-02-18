" Powerline
set rtp+=/usr/share/powerline/bindings
let g:Powerline_symbols='unicode'
let g:Powerline_theme='long'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'

if has ('termguicolors')
  set termguicolors
endif

" Use the dark version of gruvbox
set background=dark

" let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
