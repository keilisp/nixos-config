" Powerline
set rtp+=/usr/share/powerline/bindings
let g:Powerline_symbols='unicode'
let g:Powerline_theme='long'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

set background=light

if has ('termguicolors')
  set termguicolors
endif

let g:solarized_termcolors=256
colorscheme solarized
