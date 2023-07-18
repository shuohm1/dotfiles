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

# completion settings
# -U: do not expand aliases during autoload
# -z: force zsh format
# see: https://medium.com/@rukurx/ad471efd84c3
autoload -Uz compinit
if [ -z "${ZCOMPDUMP}" ]; then
  compinit
else
  compinit -d "${ZCOMPDUMP}"
fi

# complementor for sudo.vim
# see: https://blog.besky-works.net/2012/04/sudovim-zsh.html
# see: https://www.yuuan.net/item/736
function zshcomp_sudovim() {
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
compdef zshcomp_sudovim vim

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
bindkey -d  # reset
bindkey -e  # emacs mode
bindkey '^U'   backward-kill-line  # <C-u>
bindkey '^]'   vi-find-next-char   # <C-]>
bindkey '^[^]' vi-find-prev-char   # <Meta> <C-]>

# for screen
# - WINDOWTITLE: \ekWINDOWTITLE\e\\
# -  HARDSTATUS: \e_HARDSTATUS\e\\
function set_title4screen() {
  if [ -n "${WINTITLE}" ]; then return; fi

  # NOTE: never mind if these substitutions make wrong messages
  local p="$1"
  # remove leading/trailing braces, parentheses, and spaces
  p="$(echo "$p" | command sed -E 's/^[{( ]+//; s/[ )}]+$//')"
  # remove assignments of environment variables
  # \x22: a double quotetion sign
  # \x27: a single quotation sign
  p="$(echo "$p" | command sed -E 's/^([_a-zA-Z0-9]+=([^ ]*|\x22[^\x22]*\x22|\x27[^\x27]*\x27) +)+//')"

  # set a window title
  echo -ne "\ek${p%% *}\e\\"

  if [ "$p" = "${p#* }" ]; then return; fi
  p="${p#* }"

  # remove control characters
  p="$(echo "$p" | tr -d '[:cntrl:]')"
  # truncate in 256 bytes
  p="$(echo "$p" | cut --bytes=-256)"
  # reverse colors (string escapes of screen)
  # \x05  : an escape sequence
  # %{+r} : exchange foreground and background color
  # %{-}  : revert colors
  p="$(echo "$p" | LC_ALL=C command sed -E 's/([\x80-\xFF]+)/\x05{+r}\1\x05{-}/g')"
  # replace non-ascii characters with '?'
  p="$(echo "$p" | LC_ALL=C command sed -E 's/[\x80-\xFF]/?/g')"

  # set a hardstatus
  echo -ne "\e_$p\e\\"
}
function reset_title4screen() {
  local p="${WINTITLE}"
  if [ -z "$p" ]; then
    p="${HOSTNAME}"
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
    # just before the command is executed
    preexec() {
      set_title4screen "$1"
    }
    # just before the prompt shows
    precmd() {
      reset_title4screen
    }
    ;;
esac

# expand environment variables in the prompt
setopt prompt_subst
# prompt
function() {
  local p=""
  p="$p%("          # if
  #                 #   %(X.---.---) means if %X then---else---fi
  p="$p?"           #   %?: exit status of the previous command ($?)
  p="$p."           # then
  p="$p%F{green}"   #   color between %F{color}---%f
  p="$p."           # else
  p="$p%F{red}"     #   %F{red}
  p="$p)"           # fi
  p="$p%n"          # user name
  p="$p@"           # @
  p="$p\$HOSTNAME"  # hostname (instead of %m)
  p="$p:"           # :
  p="$p%~"          # current directory
  p="$p%#"          # '#' if root, otherwise '%'
  p="$p "           # space
  p="$p%f"          # end of the color setting
  PROMPT="$p"
}

# show the right prompt only on the latest command line
setopt transient_rprompt
# right prompt
function right_prompt_git() {
  local g="$(command which git 2> /dev/null)"
  if [ ! -x "$g" ]; then return; fi

  local gstatus="$($g status 2>&1 | tr 'A-Z' 'a-z')"
  if [[ "${gstatus}" =~ (not a git repository) ]]; then return; fi

  local gbranch="$($g rev-parse --abbrev-ref HEAD 2> /dev/null)"
  if [[ -z "${gstatus}" || -z "${gbranch}" ]]; then return; fi

  # try to get a commit ID instead of 'HEAD'
  if [ "${gbranch}" = "HEAD" ]; then
    gbranch="$($g rev-parse HEAD 2> /dev/null)"
    gbranch="$(echo "${gbranch}" | command grep -m1 -o -E '^.{,7}')"
  fi

  # prefix (broken vertical bar)
  local v="\u00A6"
  # suffix
  local u=
  if [[ "${gstatus}" =~ (untracked files) ]]; then
    u="?"
  fi

  local p="$gbranch"
  if [[ "${gstatus}" =~ (unmerged paths) ]]; then
    v="%F{red}$v%f"
    u="%F{red}$u%f"
    p="$v%F{white}%K{red}$p%k%f$u"
  elif [[ "${gstatus}" =~ (still merging|rebase in progress) ]]; then
    v="%F{yellow}$v%f"
    u="%F{yellow}$u%f"
    p="$v%F{black}%K{yellow}$p%k%f$u"
  elif [[ "${gstatus}" =~ (working (directory|tree) clean) ]]; then
    p="%F{green}$v$p$u%f"
  elif [[ "${gstatus}" =~ (changes not staged for commit) ]]; then
    p="%F{red}$v$p$u%f"
  elif [[ "${gstatus}" =~ (changes to be committed) ]]; then
    p="%F{yellow}$v$p$u%f"
  elif [[ "${gstatus}" =~ (untracked files) ]]; then
    p="%F{cyan}$v$p$u%f"
  else
    # unknown status
    v="%F{blue}$v%f"
    u="?"
    p="$v%F{white}%K{blue}$p$u%k%f"
  fi

  echo -n " $p"
}
RPROMPT="\$(right_prompt_git)"

# disable CTRL-S (stop the terminal output temporarily)
# NOTE: check $SSH_TTY since an error may occur with scp
# see: https://linux.just4fun.biz/?%E9%80%86%E5%BC%95%E3%81%8DUNIX%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89/Ctrl%2BS%E3%81%AB%E3%82%88%E3%82%8B%E7%AB%AF%E6%9C%AB%E3%83%AD%E3%83%83%E3%82%AF%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
if [ -n "${SSH_TTY}" ]; then
  # if you want to re-enable CTRL-S, run 'stty stop ^S'
  stty stop undef
fi

# aliases
if [ -f "${HOME}/.aliasrc" ]; then
  source "${HOME}/.aliasrc"
fi

if [ -f "${HOME}/.zshrc.local" ]; then
  source "${HOME}/.zshrc.local"
fi
