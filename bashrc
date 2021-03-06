# .bashrc

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

if [ -f ~/.bashrc.env ]; then
  source ~/.bashrc.env
fi

# return if non-interactive shells
if [ -z "${PS1}" ]; then
  return
fi

# show startup message
RCDATE="$(date +"%Y/%m/%d %H:%M:%S")"
# note: 1 is bold
# note: 30-37 are [black, red, green, yellow, blue, magenta, cyan, white]
echo -e "\e[1;37m${SHELL} started on ${RCDATE}\e[m"
# terminal title
case $TERM in
  xterm*)
    echo -en "\033]0;${USER}@${LONGHOSTNAME}\007"
    ;;
esac

# dipatch PROMPT_COMMAND
# see: http://qiita.com/tay07212/items/9509aef6dc3bffa7dd0c
function dispatch_prcmd() {
  # save the last status
  export EXIT_STATUS="$?"
  # run PROMPT_COMMAND_*
  local f
  for f in ${!PROMPT_COMMAND_*}; do
    eval "${!f}"
  done
  unset f
}
export PROMPT_COMMAND="dispatch_prcmd"

# command histories
export HISTFILE=~/.bash_history
# the number of histories on RAM
export HISTSIZE=100000
# the number of histories on HISTFILE
export HISTFILESIZE=100000
# ignore duplicate commands
#export HISTCONTROL=ignoredups
# ignore commands which start with whitespace
#export HISTCONTROL=ignorespace
# enable both 'ignoredups' and 'ignorespace'
export HISTCONTROL=ignoreboth
# appending mode (NOT overwriting)
shopt -s histappend
# save a history to HISTFILE before the prompt is shown
export PROMPT_COMMAND_HISTSAVE="history -a"

# renditions of the prompt
function set_psrend() {
  local pscolor
  if [ "${EXIT_STATUS:-0}" -eq 0 ]; then
    # success: cyan
    pscolor=36
  else
    # failed: magenta
    pscolor=35
  fi
  export PS_RENDITION="\e[${pscolor}m"
  unset pscolor
}
export PROMPT_COMMAND_PSRENDITION="set_psrend"

# prompt
function set_prompt() {
  # - escape $ symbols to set renditions every time
  # - \[ and \] cannot work in command substitutions,
  #   so use \001 and \002 instead
  local rend="\$(echo -en "\\001\${PS_RENDITION:-}\\002")"

  local p=""
  p="$p\[\e[m\]"    # reset renditions
  p="$p$rend"       # set renditions
  p="$p\u"          # user name
  p="$p@"           # @
  p="$p\h"          # host name
  p="$p:"           # :
  p="$p\w"          # current directory
  p="$p\\$"         # '#' if root, otherwise '$'
  p="$p "           # space
  p="$p\[\e[m\]"    # reset renditions
  export PS1="$p"
  unset p
}
set_prompt

# for screen
function set_title4screen() {
  local wintitle="${WINTITLE}"
  if [ -z "${wintitle}" ]; then
    wintitle="${HOSTNAME}"
    if [ "${wintitle:-localhost}" = "localhost" ]; then
      wintitle="${SHELL##*/}"
    fi
  fi

  # window title: \ek WINDOWTITLE \e\\
  echo -en "\ek${wintitle}\e\\"
  # hardstatus: \e_ HARDSTATUS \e\\
  echo -en "\e_\e\\"
}
case $TERM in
  screen*)
    export PROMPT_COMMAND_TITLE4SCREEN="set_title4screen"
    ;;
esac

# disable ctrl+s (stop the terminal output temporarily)
# note: an error may occur if scp, check SSH_TTY
# see: https://linux.just4fun.biz/?逆引きUNIXコマンド/Ctrl+Sによる端末ロックを無効にする方法
if [ "${SSH_TTY}" ]; then
  # if you want to re-enable ctrl+s, run 'stty stop ^S'
  stty stop undef
fi

# aliases
if [ -f ~/.aliasrc ]; then
  source ~/.aliasrc
fi

if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
