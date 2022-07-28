# .zshrc
ZSHRC=${(%):-%N}
# (%) : expand prompt-style %-escapes
#       (see: man zshexpn)
# %N  : the name of a script, sourced file, or shell function
#       which is most recently loaded by zsh
#       (see: man zshmisc)

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

# set some environment variables again
set_shpath "$0"
set_hostname

# completion settings
# -U: do not expand aliases during autoload
# -z: force zsh format
# see: https://medium.com/@rukurx/ad471efd84c3
autoload -Uz compinit
if [ -z "${ZCOMPDUMP}" ]; then
  compinit
else
  compinit -d ${ZCOMPDUMP}
fi

# complementor for sudo.vim
# see: https://blog.besky-works.net/2012/04/sudovim-zsh.html
# see: https://www.yuuan.net/item/736
function _mycompfunc_sudovim() {
  local LAST="${words[$#words[*]]}"
  case "${LAST}" in
    sudo:*)
      local BASEDIR="${LAST##sudo:}"
      BASEDIR="${~BASEDIR}"
      [ -d "${BASEDIR}" ] && BASEDIR="${BASEDIR%%/}/"
      compadd -P 'sudo:' -f $(print ${BASEDIR}*) \
      && return 0
      ;;
    *)
      _vim && return 0
      ;;
  esac

  return 1
}
compdef _mycompfunc_sudovim vim

# do not beep when completion
setopt nolistbeep
# complement for --foo=bar
setopt magic_equal_subst
# disable switching completions
unsetopt auto_menu

# command histories
# share the history file with bash
export HISTFILE="${HOME}/.bash_history"
# the number of histories on RAM
export HISTSIZE=100000
# the number of histories on HISTFILE
export SAVEHIST=100000
# appending mode (NOT overwriting)
setopt append_history
# ignore duplicate commands
setopt hist_ignore_dups
# ignore commands which start with whitespace
setopt hist_ignore_space
# ignore a `history` command itself
setopt hist_no_store
# remove extra whitespaces
setopt hist_reduce_blanks
# save a history immediately
setopt inc_append_history
# do not record a time
unsetopt extended_history
# do not share histories among shells
unsetopt share_history

# key bindings
bindkey -d     # reset
bindkey -e     # emacs mode
bindkey '^]'   vi-find-next-char # <C-]>
bindkey '^[^]' vi-find-prev-char # <Meta> <C-]>

# prompt
function set_prompt() {
  local p=""
  p=""
  p="$p%("        # if
  #               #   %(X.---.---) : if %X then --- else --- fi
  p="$p?"         #   %?: exit status of the previous command ($?)
  p="$p."         # then
  p="$p%F{green}" #   color between %F{color} --- %f
  #               #   0: black; 1: red; 2: green; 3: yellow
  #               #   4: blue; 5: magenta; 6: cyan; 7: white
  #               #   note: background color can be set by %K{color} --- %k
  #               #   http://qiita.com/mollifier/items/40d57e1da1b325903659
  p="$p."         # else
  p="$p%F{red}"   #   %F{red}
  p="$p)"         # fi
  p="$p%n"        # user name
  p="$p@"         # @
  p="$p%m"        # host name
  p="$p:"         # :
  p="$p%~"        # current directory
  p="$p%#"        # '#' if root, otherwise '%'
  p="$p "         # space
  p="$p%f"        # end of the color setting
  PROMPT="$p"
  unset p
}
set_prompt

# for screen
case $TERM in
  # window title: \ek WINDOWTITLE \e\\
  #   hardstatus: \e_ HARDSTATUS  \e\\
  screen*)
    # just before the command is executed
    preexec() {
      local args="$1"
      args="$(echo "${args}" | sed 's/^ *//')"
      args="$(echo "${args}" | sed 's/^(\(.*\))$/\1/')"
      args="$(echo "${args}" | sed 's/^\([^ ]\+=[^ ]\+ \+\)*//')"

      local wintitle="${WINTITLE}"
      if [ -z "${wintitle}" ]; then
        # get the first token
        wintitle="${args%% *}"
      fi
      echo -ne "\ek${wintitle}\e\\"

      if [ -z "${WINTITLE}" -a "${args}" != "${args#* }" ]; then
        # get arguments
        local hardst="${args#* }"

        # remove control characters
        hardst="$(echo "${hardst}" | tr -d "[:cntrl:]")"
        # truncate in 256 bytes
        hardst="$(echo "${hardst}" | cut --bytes=-256)"
        # reverse colors (string escapes of screen)
        # \x05  : an escape sequence
        # %{+r} : exchange foreground and background color
        # %{-}  : revert colors
        local sedscript='s/\([\x80-\xFF]\+\)/\x05{+r}\1\x05{-}/g'
        hardst="$(echo "${hardst}" | LC_ALL=C sed ${sedscript})"
        # replace non-ascii characters with '?'
        hardst="$(echo "${hardst}" | LC_ALL=C sed 's/[\x80-\xFF]/?/g')"

        echo -ne "\e_${hardst}\e\\"
      fi
    }
    # just before the prompt shows
    precmd() {
      local wintitle="${WINTITLE}"
      if [ -z "${wintitle}" ]; then
        wintitle="${HOSTNAME}"
        if [ "${wintitle:-localhost}" = "localhost" ]; then
          wintitle="${SHELL##*/}"
        fi
      fi
      echo -en "\ek${wintitle}\e\\"
      echo -en "\e_\e\\"
    }
    ;;
esac

# disable ctrl+s (stop the terminal output temporarily)
# note: an error may occur if scp, check SSH_TTY
# see: https://linux.just4fun.biz/?%E9%80%86%E5%BC%95%E3%81%8DUNIX%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89/Ctrl%2BS%E3%81%AB%E3%82%88%E3%82%8B%E7%AB%AF%E6%9C%AB%E3%83%AD%E3%83%83%E3%82%AF%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
if [ "${SSH_TTY}" ]; then
  # if you want to re-enable ctrl+s, run 'stty stop ^S'
  stty stop undef
fi

# aliases
if [ -f "${HOME}/.aliasrc" ]; then
  source "${HOME}/.aliasrc"
fi

if [ -f "${HOME}/.zshrc.local" ]; then
  source "${HOME}/.zshrc.local"
fi
