" PWP 20040101

""" Vim View Options
syntax on
set background=dark

""" Vim Encryption
set cryptmethod=blowfish2

""" Vim Functionality Options
set spell spelllang=en_us
set nocompatible
set mouse=
set ttymouse=
set ruler
set backspace=2
"set backspace=indent,eol,start

""" Vim Distro Options...
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set encoding=utf-8
scriptencoding utf-8
setglobal fileencoding=utf-8
