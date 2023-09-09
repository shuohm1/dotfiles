# .bashrc
BASHRC="${BASH_SOURCE[0]}"
BASHRCDIR="${BASHRC%/*}"
RSLV_BASHRC="$(readlink -e "${BASHRC}" 2> /dev/null)"
RSLV_BASHRCDIR="${RSLV_BASHRC%/*}"

# TODO: unsource a system wide bashrc file
if [ -f "/etc/bashrc" ]; then
  source "/etc/bashrc"
fi

# ensure interactive shells
if [ -z "${PS1}" ]; then
  return
fi

# environment
source "${HOME}/.bashrc.env"

# aliases
if [ -f "${BASHRCDIR}/.bash_aliases" ]; then
  source "${BASHRCDIR}/.bash_aliases"
elif [ -f "${RSLV_BASHRCDIR}/.bash_aliases" ]; then
  source "${RSLV_BASHRCDIR}/.bash_aliases"
else
  echo "NOT FOUND: .bash_aliases" 1>&2
fi

# functions
if [ -f "${BASHRCDIR}/.bash_funcs" ]; then
  source "${BASHRCDIR}/.bash_funcs"
elif [ -f "${RSLV_BASHRCDIR}/.bash_funcs" ]; then
  source "${RSLV_BASHRCDIR}/.bash_funcs"
else
  echo "NOT FOUND: .bash_funcs" 1>&2
fi

# show a startup message
startup_message

# a terminal title
case "${TERM}" in
  xterm*)
    send_terminaltitle "${USER}@${HOSTNAME}"
    ;;
  putty*)
    send_terminaltitle "${USER}@${HOSTNAME} - PuTTY"
    ;;
esac

# dipatch PROMPT_COMMAND
# cf. http://qiita.com/tay07212/items/9509aef6dc3bffa7dd0c
function dispatch_precmd() {
  # save the last status
  LAST_STATUS=$?
  # run PROMPT_COMMAND_*
  local f=
  for f in ${!PROMPT_COMMAND_*}; do
    eval "${!f}"
  done
}
PROMPT_COMMAND="dispatch_precmd"

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
PROMPT_COMMAND_HISTSAVE="history -a"

# for screen
if [[ "${TERM}" = screen* ]]; then
  PROMPT_COMMAND_RESET_WINDOWTITLE="reset_windowtitle"
  PROMPT_COMMAND_RESET_HARDSTATUS="reset_hardstatus"
fi

# color of the prompt
function update_pscolor() {
  if [ "${LAST_STATUS:-0}" -eq 0 ]; then
    # success: cyan
    PSCOLOR=36
  else
    # failed: blue
    PSCOLOR=34
  fi
}
PROMPT_COMMAND_PSCOLOR="update_pscolor"

# prompt
function init_prompt() {
  local p=
  p="$p\["               # begin an invisible section
  p="$p\e[m"             # reset renditions
  p="$p\e[\${PSCOLOR}m"  # set color
  p="$p\]"               # end an invisible section
  p="$p\u"               # a user name
  p="$p@"                # an at sign
  p="$p\${FORENAME}"     # a host name (instead of \h)
  p="$p:"                # a colon
  p="$p\w"               # the current directory
  p="$p\\$"              # '#' if root, otherwise '$'
  p="$p "                # a whitespace
  p="$p\[\e[m\]"         # reset renditions
  PS1="$p"
}
init_prompt

# disable XON (Ctrl-Q) and XOFF (Ctrl-S) when interactive shells
# cf. https://linuxfan.info/disable-ctrl-s
if [ -t 0 ]; then
  stty start undef  # XON
  stty stop undef   # XOFF
fi

if [ -f "${HOME}/.bashrc.local" ]; then
  source "${HOME}/.bashrc.local"
fi
