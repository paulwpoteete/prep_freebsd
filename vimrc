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
