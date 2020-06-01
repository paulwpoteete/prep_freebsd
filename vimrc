syntax on
set cryptmethod=blowfish2
set background=dark
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set mouse=
set ttymouse=

set ruler

set backspace=2

set encoding=utf-8
scriptencoding utf-8
setglobal fileencoding=utf-8
