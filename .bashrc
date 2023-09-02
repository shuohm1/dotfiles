# .bashrc
RCEPOCH="$(date "+%s.%N")"

BASHRC="${BASH_SOURCE[0]}"
BASHRCDIR="${BASHRC%/*}"
RSLV_BASHRC="$(readlink -e "${BASHRC}" 2> /dev/null)"
RSLV_BASHRCDIR="${RSLV_BASHRC%/*}"

# TODO: unsource a system wide bashrc file
if [ -f "/etc/bashrc" ]; then
  source "/etc/bashrc"
fi

# return if non-interactive shells
if [ -z "${PS1}" ]; then
  return
fi

# environment
if [ -f "${HOME}/.bashrc.env" ]; then
  source "${HOME}/.bashrc.env"
fi

# aliases
if [ -f "${RSLV_BASHRCDIR}/.unirc_alias.sh" ]; then
  source "${RSLV_BASHRCDIR}/.unirc_alias.sh"
fi

# functions
if [ -f "${RSLV_BASHRCDIR}/.unirc_func.sh" ]; then
  source "${RSLV_BASHRCDIR}/.unirc_func.sh"
fi

# show a startup message
startup_message "${RCEPOCH}"

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
# see: http://qiita.com/tay07212/items/9509aef6dc3bffa7dd0c
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

# renditions of the prompt
function update_psrendition() {
  local pscolor=
  if [ "${LAST_STATUS:-0}" -eq 0 ]; then
    # success: cyan
    pscolor=36
  else
    # failed: magenta
    pscolor=35
  fi
  PSRENDITION="\e[${pscolor}m"
}
PROMPT_COMMAND_PSRENDITION="update_psrendition"

# prompt
function init_prompt() {
  # set renditions every time
  # - a command substitution $(...) is required to interpret escape
  #   sequences
  # - escape dollar signs to prevent expanding commands and variables
  local c="\$(printf "\${PSRENDITION:-}")"

  local p=
  p="$p\[\e[m\]"    # reset renditions
  p="$p\[$c\]"      # set renditions
  p="$p\u"          # a user name
  p="$p@"           # an at sign
  p="$p\$FORENAME"  # a host name (instead of \h)
  p="$p:"           # a colon
  p="$p\w"          # the current directory
  p="$p\\$"         # '#' if root, otherwise '$'
  p="$p "           # a whitespace
  p="$p\[\e[m\]"    # reset renditions
  PS1="$p"
}
init_prompt

# disable Ctrl-S (stop the terminal output temporarily)
# NOTE: check $SSH_TTY since an error may occur with scp
# see: https://linux.just4fun.biz/?%E9%80%86%E5%BC%95%E3%81%8DUNIX%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89/Ctrl%2BS%E3%81%AB%E3%82%88%E3%82%8B%E7%AB%AF%E6%9C%AB%E3%83%AD%E3%83%83%E3%82%AF%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
if [ -n "${SSH_TTY}" ]; then
  # if you want to re-enable Ctrl-S, run 'stty stop ^S'
  stty stop undef
fi

if [ -f "${HOME}/.bashrc.local" ]; then
  source "${HOME}/.bashrc.local"
fi
