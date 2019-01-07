# .aliases.sh

# sudo でエイリアスを引き継ぐ
alias sudo="sudo "

# ls に色をつける
if ls --version 2> /dev/null | grep "GNU" 1> /dev/null 2>&1; then
  # GNU ls
  alias ls="ls --color=auto"
else
  # BSD ls
  alias ls="ls -G"
fi

# ls 拡張
alias lc="ls -C"  # 強制カラム表示
alias lx="ls -x"  # 横に並べて表示
alias la="ls -a"
alias ll="ls -l"
alias lh="ls -lh"
alias lz="ls -la" # ll + la
alias lg="ls -lG" # -G : 所属グループを表示しない

# mv, cp, rm で確認を取る
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"

# less 拡張
## 最下行に情報表示, 着色エスケープ文字を解釈, タブ幅4
export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS --tabs=4"
## シンタックスハイライト (要: GNU Source Highlight)
srchighlight=$(which src-hilite-lesspipe.sh 2>&1)
if [ ! -x "${srchighlight}" ]; then
  srchighlight=/usr/share/source-highlight/src-hilite-lesspipe.sh
fi
if [ -x "${srchighlight}" ]; then
  export LESSOPEN="| ${srchighlight} %s"
fi
#alias less="less -R" # 着色エスケープ文字を解釈
alias sless="less -S" # 画面右端で改行しない
alias xless="less -X" # 終了後に表示内容を残す

# grep 拡張
for xgrep in grep egrep fgrep zgrep zegrep zfgrep; do
  # 色をつける
  alias ${xgrep}="${xgrep} --color=auto"
  # リダイレクトやパイプでも強制的に色をつける
  alias c${xgrep}="${xgrep} --color=always"
done

# diff 拡張
if [ -x "$(which colordiff 2> /dev/null)" ]; then
  alias diff="colordiff"
fi

# screen
if [ -x "$(which screen 2> /dev/null)" ]; then
  alias s="screen"
  alias sl="screen -ls" # セッション一覧
  alias sr="screen -R"  # レジューム
  alias ss="screen -S"  # セッション名を指定して起動
fi

# ベルを鳴らす
alias bell="echo -ne '\a'"
