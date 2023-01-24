" PWP 20040101

""" Vim View Options
syntax on
set background=dark

""" Vim Encryption
set cryptmethod=blowfish2

""" Vim Spelling
set spell spelllang=en_us
" 1) mkdir -p ~/.vim/spell
" 2) touch ~/.vim/spell/en.utf-8.add
" 3) (inside vim) :mkspell! ~/.vim/spell/en.utf-8.add
" 4) Type zg over a word seen as misspelled (not a colon command)
"" zg - Add word under cursor as a good word to spellfile
"" zw - Add word under cursor as a wrong word to spellfile
"" zug - Undo zg, remove the word entry from spellfile
"" zuw - Undo zw, remove the word entry from spellfile

""" Vim Functionality Options
set nocompatible
set mouse=
set ttymouse=
set ruler
set backspace=2

""" Vim Distro Options...
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set encoding=utf-8
scriptencoding utf-8
setglobal fileencoding=utf-8
