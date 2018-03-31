### .zshrc ###
# このファイル自身のパス
ZSHRC=${(%):-%N}
#       (%)     : 変数展開フラグ (see: man zshexpn)
#               :   (%) : プロンプト用の % エスケープを展開する
#          :-   : ${VAR:-STR} : $VAR が定義されていれば $VAR, 未定義ならば STR
#               :   :- の前に変数名がないため必ず :- の後ろの文字列が使われる
#            %N : スクリプト, source されたファイル, シェル関数のうち,
#               :   zsh が最も最近実行したものの名前 (see: man zshmisc)

# 起動メッセージ
startupmessage=$(date +"${SHELL} started on: %Y/%m/%d %H:%M:%S")

# echo -e : バックスラッシュエスケープを有効化
# "<esc>[VALUE;VALUE;VALUEm" と "<esc>[m" の間に属性/色をつける
#   [属性] 0: オフ; 1: 太字; 4: 下線; 5: 点滅; 7: 反転; 8: 隠蔽
#   [前景色] 3x; [背景色] 4x; (下1桁で色を指定)
#   [色] 0: 黒; 1: 赤; 2: 緑; 3: 黄; 4: 青; 5: 紫; 6: 水; 7: 白
#   http://d.hatena.ne.jp/daijiroc/20090207/1233980551
echo -e "\e[33m${startupmessage}\e[m"

# 補完設定
## -U: ロード時にエイリアス展開しない
## -z: zsh の形式でロードする (?)
autoload -Uz compinit && compinit
## 補完時に音を鳴らさない
setopt nolistbeep
## --prefix=/usr 等のコマンドライン引数の = 以降でも補完
setopt magic_equal_subst
## 補完の順次切り替えをオフにする
unsetopt auto_menu

# コマンド履歴
export HISTFILE=~/.zsh_history
## メモリに保存される履歴の件数
export HISTSIZE=10000
## $HISTFILE に保存される履歴の件数
export SAVEHIST=100000
## $HISTFILE を追記 (非上書き) モードに設定
setopt append_history
## 重複コマンドを無視
setopt hist_ignore_dups
## history コマンドそのものは無視
setopt hist_no_store
## コマンドが入力されるとすぐに追加
setopt inc_append_history
## 異なるシェルで履歴を共有する
#setopt share_history
## 異なるシェルで履歴を共有しない
unsetopt share_history

# 色設定関数の読み込み
#autoload -Uz colors && colors

# キーバインド
bindkey -d     # リセット
bindkey -e     # emacs モード読み込み
bindkey '^]'   vi-find-next-char # <C-]>
bindkey '^[^]' vi-find-prev-char # <Meta> <C-]>

# Ctrl+S で端末表示を止める機能を無効にする
# ただし scp 時にエラーが出る可能性があるので $SSH_TTY をチェック
# see: http://linux.just4fun.biz/逆引きUNIXコマンド/Ctrl%2BSによる端末ロックを無効にする方法.html
if [ "$SSH_TTY" != "" ]; then
  # 再定義する場合は stty stop ^S
  stty stop undef
fi

# エイリアス
## 基本エイリアス
[ -f ~/.aliases_basic ] && . ~/.aliases_basic
## aptitude
[ -f ~/.aliases_apt ] && . ~/.aliases_apt
## Homebrew
[ -f ~/.aliases_brew ] && . ~/.aliases_brew

# シェル関数
## GUI版 Emacs
[ -f ~/.funcs_gmacs ] && . ~/.funcs_gmacs

case $TERM in
  # - screen のウィンドウ名を変更する
  #   "<esc>kウィンドウ名<esc>\" を出力することで変更できる
  # - ハードステータスにメッセージを出力する
  #   "<esc>_メッセージ<esc>\" でハードステータスに出力できる
  # - echo -e : バックスラッシュエスケープを有効化
  screen*)
    # 文字化け対策
    ## 制御文字の除去
    del_ctrlchar() {
      echo -n "$*" | tr -d "[:cntrl:]"
    }
    ## 256 バイトまでに制限
    rst_upto256b() {
      echo -n "$*" | cut --bytes=-256
    }
    ## 色反転
    rev_nonascii() {
      # %{+r} : 背景色と前景色を入れ替える
      # %{-}  : 元に戻す
      #                           's/ ([:non-ascii:]+)/   %{+r}()   %{-}/g'
      echo -n "$*" | LC_ALL=C sed 's/\([\x80-\xFF]\+\)/\x05{+r}\1\x05{-}/g'
    }
    ## `?' に置換
    sub_nonascii() {
      #                           's/[non-ascii]/?/g'
      echo -n "$*" | LC_ALL=C sed 's/[\x80-\xFF]/?/g'
    }
    # コマンド実行直前
    preexec() {
      # ウィンドウ名
      ## コマンド名のみを抽出
      ## ${X%% *} で " *" にマッチする最長接尾部を除去
      windowtitle=${1%% *}
      ## 文字化け対策
      windowtitle=$(del_ctrlchar "${windowtitle}")
      windowtitle=$(sub_nonascii "${windowtitle}")
      ## 出力
      echo -ne "\ek${windowtitle}\e\\"
      # ハードステータス
      ## コマンドの引数を抽出
      ## ${X#* } で "* " にマッチする最短接頭部を除去
      hardstatus=${1#* }
      ## 引数がある場合のみ出力
      if [ "$1" != "${hardstatus}" ]; then
        ## 文字化け対策
        hardstatus=$(del_ctrlchar "${hardstatus}")
        hardstatus=$(rst_upto256b "${hardstatus}")
        hardstatus=$(rev_nonascii "${hardstatus}")
        hardstatus=$(sub_nonascii "${hardstatus}")
        ## 出力
        echo -ne "\e_${hardstatus}\e\\"
      fi
    }
    # コマンド実行直後
    precmd() {
      # $SHELL のファイル名のみを抽出
      # ${X##*/} で "*/" にマッチする最長接頭部を除去
      windowtitle=${SHELL##*/}
      echo -ne "\ek${windowtitle}\e\\"
      # ハードステータスを空にする
      echo -ne "\e_\e\\"
    }
    ;;
esac

# プロンプト
a=""
a="$a%("        # if
#               #   %(X.---.---) : if %X then --- else --- fi
a="$a?"         #   %? : 直前のコマンドの実行結果 ($?)
a="$a."         # then
a="$a%F{green}" #   %F{color} --- %f 間に色をつける (番号または色名)
#               #   0: black; 1: red; 2: green; 3: yellow
#               #   4: blue; 5: magenta; 6: cyan; 7: white
#               #   %K{color} --- %k で囲むと背景色が指定できる
#               #   http://qiita.com/mollifier/items/40d57e1da1b325903659
a="$a."         # else
a="$a%F{red}"   #   %F{red}
a="$a)"         # fi
a="$a%n"        # ユーザ名
a="$a@"         # @
a="$a%m"        # ホスト名
a="$a:"         # :
a="$a%~"        # カレントディレクトリ
a="$a%#"        # ルートなら #; それ以外なら %
a="$a "         # space
a="$a%f"        # ここまで色をつける
PROMPT="$a"
unset a
