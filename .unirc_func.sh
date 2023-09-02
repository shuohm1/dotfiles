# .unirc_func.sh

function ensure_asciichars() {
  printf "$(printf "$1" | LANG=C tr -c '[:cntrl:][:print:]' '[?*]')\n"
}

function startup_message() {
  local t="${1:-$(date "+%s")}"
  t="$(LC_ALL=C date --date="@${t%%.*}" "+%F(%a) %T")"

  local tput="$(command which tput 2> /dev/null)"
  local width=0
  if [ -x "${tput}" ]; then
    width="$(${tput} cols)"
  fi

  # NOTE:
  # - \e[1m: bold
  # - \e[4m: underline
  # - \e[nG: set the cursor position onto the n-th letter (1-origin)
  local pos="$(( ${width} - ${#t} ))"
  if [ "${pos}" -le "$(( ${#SHELL} + 2 ))" ]; then
    printf "\e[1m${SHELL}\e[m: \e[1;4m$t\e[m\n"
  else
    printf "\e[1m${SHELL}\e[m:\e[${pos}G\e[1;4m$t\e[m\n"
  fi
}

function send_terminaltitle() {
  case "${TERM}" in
    screen*|tmux*)
      return
      ;;
  esac

  # \e]0;${TERMINALTITLE}\a
  printf "\x1B\x5D\x30\x3B$(ensure_asciichars "$1")\x07"
}

function send_windowtitle() {
  if [[ "${TERM}" = screen* ]]; then
    # \ek${WINDOWTITLE}\e\\
    printf "\x1B\x6B$(ensure_asciichars "$1")\x1B\x5C"
  fi
}

function send_hardstatus() {
  if [[ "${TERM}" = screen* ]]; then
    # \e_${HARDSTATUS}\e\\
    printf "\x1B\x5F$(ensure_asciichars "$1")\x1B\x5C"
  fi
}

function reset_windowtitle() {
  local t="${WINDOWTITLE}"
  if [ -z "$t" ]; then
    t="${FORENAME}"
    if [ "${t:-localhost}" = "localhost" ]; then
      t="${SHELL##*/}"
    fi
  fi
  send_windowtitle "$t"
}

function reset_hardstatus() {
  send_hardstatus "${HARDSTATUS}"
}
