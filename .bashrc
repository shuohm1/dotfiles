# .bashrc

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

if [ -f "${HOME}/.bashrc.env" ]; then
  source "${HOME}/.bashrc.env"
fi

# return if non-interactive shells
if [ -z "${PS1}" ]; then
  return
fi

function get_termcols() {
  local tput="$(command which tput 2> /dev/null)"
  if [ -x "${tput}" ]; then
    "${tput}" cols
  else
    echo 0
  fi
}

# show startup message
RCDATE="$(LC_ALL=C date +"%F(%a) %T")"
RCDATEPOS=$(($(get_termcols) - ${#RCDATE}))
# NOTE:
# - \e[1m: bold
# - \e[4m: underline
# - \e[nG: set the cursor position onto the n-th letter (1-origin)
if [ ${RCDATEPOS} -le $((${#SHELL} + 2)) ]; then
  echo -e "\e[1m${SHELL}\e[m: \e[1m${RCDATE}\e[m"
else
  echo -e "\e[1m${SHELL}\e[m:\e[${RCDATEPOS}G\e[1;4m${RCDATE}\e[m"
fi
# terminal title
case $TERM in
  xterm*)
    echo -en "\033]0;${USER}@${HOSTNAME}\007"
    ;;
esac

# dipatch PROMPT_COMMAND
# see: http://qiita.com/tay07212/items/9509aef6dc3bffa7dd0c
function dispatch_prcmd() {
  # save the last status
  export EXIT_STATUS="$?"
  # run PROMPT_COMMAND_*
  local f=
  for f in ${!PROMPT_COMMAND_*}; do
    eval "${!f}"
  done
}
export PROMPT_COMMAND="dispatch_prcmd"

# command histories
export HISTFILE="${HOME}/.bash_history"
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

# for screen
# - WINDOWTITLE: \ekWINDOWTITLE\e\\
# -  HARDSTATUS: \e_HARDSTATUS\e\\
function set_title4screen() {
  local p="${WINTITLE}"
  if [ -z "$p" ]; then
    p="${FORENAME}"
    if [ "${p:-localhost}" = "localhost" ]; then
      p="${SHELL##*/}"
    fi
  fi
  # set a window title
  echo -en "\ek$p\e\\"
  # clear a hardstatus
  echo -en "\e_\e\\"
}

case $TERM in
  screen*)
    export PROMPT_COMMAND_TITLE4SCREEN="set_title4screen"
    ;;
esac

# renditions of the prompt
function set_psrend() {
  local pscolor=
  if [ "${EXIT_STATUS:-0}" -eq 0 ]; then
    # success: cyan
    pscolor=36
  else
    # failed: magenta
    pscolor=35
  fi
  export PS_RENDITION="\e[${pscolor}m"
}
export PROMPT_COMMAND_PSRENDITION="set_psrend"

# prompt
function init_prompt() {
  # set renditions every time
  # - a command substitution $(echo -e ...) is required
  #   to interpret escape sequences
  # - escape $ symbols to prevent expanding commands and variables
  local rend="\$(echo -en "\${PS_RENDITION:-}")"

  local p=
  p="$p\[\e[m\]"    # reset renditions
  p="$p\[$rend\]"   # set renditions
  p="$p\u"          # user name
  p="$p@"           # @
  p="$p\$FORENAME"  # hostname (instead of \h)
  p="$p:"           # :
  p="$p\w"          # current directory
  p="$p\\$"         # '#' if root, otherwise '$'
  p="$p "           # space
  p="$p\[\e[m\]"    # reset renditions
  echo "$p"
}
export PS1="$(init_prompt)"

# disable Ctrl-S (stop the terminal output temporarily)
# NOTE: check $SSH_TTY since an error may occur with scp
# see: https://linux.just4fun.biz/?%E9%80%86%E5%BC%95%E3%81%8DUNIX%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89/Ctrl%2BS%E3%81%AB%E3%82%88%E3%82%8B%E7%AB%AF%E6%9C%AB%E3%83%AD%E3%83%83%E3%82%AF%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
if [ -n "${SSH_TTY}" ]; then
  # if you want to re-enable Ctrl-S, run 'stty stop ^S'
  stty stop undef
fi

# aliases
if [ -f "${HOME}/.aliasrc" ]; then
  source "${HOME}/.aliasrc"
fi

if [ -f "${HOME}/.bashrc.local" ]; then
  source "${HOME}/.bashrc.local"
fi
