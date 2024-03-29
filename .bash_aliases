# .bash_aliases

# delete all aliases in advance
unalias -a

# expand aliases with sudo
# cf. https://qiita.com/homines22/items/ba1a6d03df85e65fc85a
alias sudo="sudo "

# directory stack
alias pd="pushd"
alias bd="popd"
alias ud="pushd -"
# always print the directory stack with one entry per line
alias dirs="dirs -p"

# ls
alias ls="ls -v --color=auto"
alias la="ls -A"     # almost all
alias le="ls -a -l"  # everything
alias lf="ls -l -H"  # follow symlinks on the command line
alias lg="ls -g -o"  # do not list owner/group
alias lh="ls -h -l"  # human readable
alias ll="ls -l"     # long
alias ly="ls -l -L"  # follow all symlinks
alias lt="ls -l --time-style='+%F %T.%3N'"
# more details
alias laa="la -l"
alias lff="lf -a"
alias lgg="lg -a"
alias lhh="lh -a"
alias lll="ll -a"
alias lyy="ly -a"
alias ltt="lt -a"

# always prompt before overwrite with mv/cp/rm
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"

# less
alias lless="less -L"  # ignore LESSOPEN
alias nless="less -N"  # with line numbers
alias sless="less -S"  # do not wrap on the right edge
alias xless="less -X"  # leave displayed contents

# grep
alias grep="grep --color=auto"
alias egrep="grep -E"
alias fgrep="grep -F"
alias pgrep="grep -P"
alias rgrep="grep -r"
alias bgrep="command grep"  # basic regex
alias gr="egrep"

# sed
alias sed="sed -E"
alias bsed="command sed"  # basic regex

# colordiff
alias diff="diff -u"
if [ -x "$(command which colordiff 2> /dev/null)" ]; then
  alias diff="colordiff -u"
fi
alias cdiff="command diff"  # copied context

# screen
alias sc="screen"
alias sl="screen -ls"  # list sessions
alias sr="screen -R"   # resume a session
alias sn="screen -S"   # set a session name

# vim
alias vi="vim"
alias view="vim -R"

# git
alias g="git status"
alias gf="git fetch"
alias gm="git merge --no-ff"
alias gw="git where-i-am"
alias gco="git checkout"
alias gsw="git switch"
alias gull="git pull --ff-only"
alias gush="git push"
# git add
alias ga="git add"
alias gap="git add --patch"
# git branch
alias gb="git branch"
alias gn="git checkout -b"
# git commit
alias gk="git commit --verbose"
alias gx="git fixup-helper"
alias gq="git squash-helper"
alias gka="git commit --allow-empty --amend --verbose"
# git diff
alias gd="git diff-helper"
alias g@="git diff-helper --cached"
# git log
alias gl="git log --abbrev-commit --all --graph --stat"
alias gp="gl --patch"
alias gg="GIT_PAGER='less -S' git log --all --graph --oneline"
alias gll="gl --pretty=fuller"
alias GL="gl --reflog"
alias GG="gg --reflog"

# sort
alias so="sort"

# while
alias wi="while read i"
alias wj="while read j"
alias wk="while read k"

# xargs
alias xargs="xargs --no-run-if-empty"
alias xa="xargs"
alias xi="xargs -I{}"

# ring a bell
alias bell="echo -ne '\a'"
