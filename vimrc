" encoding
set encoding=utf-8
scriptencoding utf-8

" シンタックスハイライト
syntax enable
" フォーマットオプション
set formatoptions=tcq

" ステータス行を常に表示
set laststatus=2

" 行番号表示/非表示
set number " abbr: nu
set ruler

" 行頭/行末間移動
"set whichwrap=h,l
" 行末で折り返す/折り返さない
set wrap
"set nowrap

" タブを空白に展開する/しない
set expandtab " abbr: et
"set noexpandtab
" 表示上のタブ幅
set tabstop=4
" vim が自動的に挿入する空白量
set shiftwidth=2
" tab キーで挿入される空白量
" (0 にすると tabstop の値が使われる)
set softtabstop=2

" 括弧の対応関係を一瞬表示する/しない
" (閉じ括弧を入力時に開き括弧に一瞬カーソルが移動する)
"set showmatch
set noshowmatch

" 入力中のコマンドを表示する
set showcmd

" 検索語句をハイライトする/しない
"set hlsearch " abbr: hls
set nohlsearch
" 検索時に英大小文字を区別しない
set ignorecase
" すべて英小文字で入力した場合のみ区別しない
set smartcase
" 検索をループする/しない
"set wrapscan
set nowrapscan
" 語句の入力途中で検索を始める/始めない
" (incremental search)
"set incsearch
set noincsearch

" ファイル名補完
set wildmode=longest,list
" バッファの hidden モードを有効にする
set hidden

" スワップファイルを作る/作らない (foobar.txt.swp)
set swapfile
"set noswapfile
" スワップファイルディレクトリ
if isdirectory("/tmp")
  set directory=/tmp
endif

" バックアップをとる/とらない (foobar.txt~)
"set backup
set nobackup
" バックアップディレクトリ
"set backupdir=

" backspace キーの挙動設定
" (手前の文字を消しつつ1文字分左に移動する)
" see: http://www.atmarkit.co.jp/ait/articles/1107/21/news115.html
set backspace=indent,eol,start

" 空白文字等の可視化
set list
"set listchars=tab:>\ ,trail:.,nbsp:%,eol:$,extends:>,precedes:<
exe "set listchars=tab:\<Char-0xBB>\\ ,trail:.,nbsp:%,eol:\<Char-0xAC>,extends:>,precedes:<"
" <Char-0xBB>: ≫
" <Char-0xAC>: ￢
" trail: 行末の空白
" extends: nowrap のとき右側の続きを示す
" precedes: nowrap のとき左側の続きを示す

" カラーテーマ
colorscheme elflord

" augroup redhat の autocmd を無効化する
if has("autocmd")
  augroup redhat
  autocmd!
  augroup END
endif

" キーバインド
"" 保存/終了
nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>q :<C-u>q<CR>
nnoremap <Space>Q :<C-u>q!<CR>
"" : と ; を入れ替える
"nnoremap ; :
"nnoremap : ;
"vnoremap ; :
"vnoremap : ;
"" 行頭/行末へ移動
nnoremap <Space>h ^
nnoremap <Space>l $
"" ファイル先頭/末尾へ移動
nnoremap <Space>k gg
nnoremap <Space>j G
"" 物理行移動と論理行 (表示行) 移動を入れ替える
"nnoremap k  gk
"nnoremap j  gj
"vnoremap k  gk
"vnoremap j  gj
"nnoremap gk k
"nnoremap gj j
"vnoremap gk k
"vnoremap gj j
" 空行挿入
nnoremap <Space>o :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>
"" 危険キーの無効化
""" 保存して終了
nnoremap ZZ <Nop>
""" 保存せずに終了
nnoremap ZQ <Nop>
