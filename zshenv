### .zshenv ###

# ロケール
export LANG=C
export LC_CTYPE=ja_JP.UTF-8
unset LC_ALL

# ホスト名
export HOSTNAME=$(hostname)

# SHELL
[ -x "$(which $0)" ] && export SHELL=$(which $0)

# TERMINFO
[ -d  "${HOME}/.terminfo" ] && export TERMINFO="${HOME}/.terminfo"

# PATH and MANPATH
for bin in /usr/local/bin /usr/local/sbin; do
	[ -d ${bin} ] && PATH="${bin}:${PATH}"
done
## 自作コマンド
[ -d ${HOME}/bin ] && PATH="${HOME}/bin:${PATH}"
## 重複を排除
typeset -U PATH MANPATH
export PATH MANPATH
