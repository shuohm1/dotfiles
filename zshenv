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

# LESSKEY
keybin="${HOME}/.less"
keysrc="${HOME}/.lesskey"
keycompiler="$(which lesskey 2>/dev/null)"
if [ ! -f "${keybin}" -a -x "${keycompiler}" -a -f "${keysrc}" ]; then
	# キーバインドファイルが存在しなければ生成
	# Note: 出力はバイナリファイル
	${keycompiler} --output "${keybin}" "${keysrc}"
fi
[ -f "${keybin}" ] && export LESSKEY="${keybin}"

# PATH and MANPATH
for bin in /usr/local/bin /usr/local/sbin; do
	[ -d ${bin} ] && PATH="${bin}:${PATH}"
done
## 自作コマンド
[ -d ${HOME}/bin ] && PATH="${HOME}/bin:${PATH}"
## 重複を排除
typeset -U PATH MANPATH
export PATH MANPATH
