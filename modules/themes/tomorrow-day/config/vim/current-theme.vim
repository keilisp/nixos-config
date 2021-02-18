" Powerline
set rtp+=/usr/share/powerline/bindings
let g:Powerline_symbols='unicode'
let g:Powerline_theme='long'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'
" let g:airline_theme='gruvbox'

" Use the dark version of gruvbox
if has ('termguicolors')
  set termguicolors
endif
set background=light

" let g:solarized_termcolors=256
" colorscheme solarized

" let g:gruvbox_contrast_dark='soft'
" colorscheme gruvbox
" colorscheme wal
" colorscheme base16-default-light
" colorscheme modus-operandi

colorscheme PaperColor
