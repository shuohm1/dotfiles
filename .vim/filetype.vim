" bash
au BufNewFile,BufRead .bash[_-]funcs*,.bash[_-]functions*	call dist#ft#SetFileTypeSH("bash")
" scala
au BufNewFile,BufRead *.scala	setf scala
