" encoding
set encoding=utf-8
scriptencoding utf-8
" cjkwidth
set ambiwidth=double

" colors
colorscheme elflord
" syntax highlight
syntax enable
" syntax highlight for markdown files
autocmd BufNewFile,BufRead *.md set filetype=markdown

" status line
" - 0: do not show
" - 1: show if there are two or more windows
" - 2: show always
set laststatus=2

" show line numbers
set number
" show a position of the cursor on a status line (the lower right)
set ruler

" wrap long lines
set wrap
" move the cursor between the head/tail of lines
" * see: https://vim-jp.org/vimdoc-ja/options.html#'whichwrap'
set whichwrap=b,s

" # indent
" expand a tab-key into whitespaces
set expandtab
" appearance of tab-character width
set tabstop=4
" the number of whitespaces when a tab-key is input
set softtabstop=2
" the number of whitespaces with auto indent
set shiftwidth=2

" do not show the matching parenthesis
" (the cursor moves the left parenthesis for an instant when
"  the right parenthesis is input; disable this function)
set noshowmatch

" show a command under typing
set showcmd

" # search
" do not highlight a word under searching
set nohlsearch
" ignore upper/lower-case letters when searching
set ignorecase
" ignore case only if all letters in the searching word are lowercase
set smartcase
" do not loop searching
set nowrapscan
" disable incremental search
" (do not begin to search in the middle of typing)
set noincsearch

" a completion mode for a name of a file
" * see: https://vim-jp.org/vimdoc-ja/options.html#'wildmode'
set wildmode=longest,list
" enable hidden (inactive) buffers
set hidden

" # swap/backup
" make swap files (foobar.txt.swp)
set swapfile
" a list of directories for swap files
" - a trailing '//' sets a name of a swap file based on its full path
" - '.' means the same directory with an editing file
set directory=$HOME/tmp/.vimswap//,$HOME/.vimswap//,.
" writebackup: make backup files only during writing
"    nobackup: remove those backup files if success to write
set nobackup
set writebackup
" a list of directories for backup files
set backupdir=$HOME/tmp/.vimbackup//,$HOME/tmp//,.

" a setting for the backspace key
" * see: https://vim-jp.org/vimdoc-ja/options.html#'backspace'
" * see: http://www.atmarkit.co.jp/ait/articles/1107/21/news115.html
set backspace=indent,eol,start

" visualize whitespace, tab, etc.
set list
"set listchars=tab:>\ ,trail:.,nbsp:%,eol:$,extends:>,precedes:<
exe "set listchars=tab:\<Char-0xBB>\\ ,trail:.,nbsp:%,eol:\<Char-0xAC>,extends:>,precedes:<"
" - <Char-0xBB>: half-width version of ≫
" - <Char-0xAC>: half-width version of ￢
" -       trail: whitespaces on the tail of a line
" -     extends: continuation on the right (with nowrap mode)
" -    precedes: continuation on the left (with nowrap mode)

" # key bindings
" save/exit
nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>q :<C-u>q<CR>
nnoremap <Space>Q :<C-u>q!<CR>
" swap colon and semicolon
"nnoremap ; :
"nnoremap : ;
"vnoremap ; :
"vnoremap : ;
" move the cursor to the head/tail of the line
nnoremap <Space>h ^
nnoremap <Space>l $
" move the cursor to the top/bottom of the file
nnoremap <Space>k gg
nnoremap <Space>j G
" swap moving physical lines and moving logical lines
"nnoremap k  gk
"nnoremap j  gj
"vnoremap k  gk
"vnoremap j  gj
"nnoremap gk k
"nnoremap gj j
"vnoremap gk k
"vnoremap gj j
" insert empty lines
nnoremap <Space>o :<C-u>for i in range(v:count1) <bar> call append(line('.'), '') <bar> endfor<CR>
nnoremap <Space>O :<C-u>for i in range(v:count1) <bar> call append(line('.')-1, '') <bar> endfor<CR>
" disable dangerous key bindings
" - save and exit
nnoremap ZZ <Nop>
" - exit without saving
nnoremap ZQ <Nop>

" disable format options
set formatoptions=
if has("autocmd")
  augroup disable_formatoptions
  autocmd!
  autocmd FileType * setlocal formatoptions=
  augroup END
endif
" disable autocmd with RHEL
if has("autocmd")
  augroup redhat
  autocmd!
  augroup END
endif

" local setting files
if filereadable(expand("$MYVIMRC.local"))
  source $MYVIMRC.local
elseif filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
