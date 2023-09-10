# .zshrc

# (%) expands %-escapes in the same way as in prompts (cf. man zshexpn
#     -> Parameter Expansion Flags)
# %N  is expanded into the name of script, sourced file, or shell
#     function which is most recently loaded by zsh (cf. man zshmisc ->
#     Prompt Expansion -> Shell State)
ZSHRC="${(%):-%N}"
# :h works like `dirname` (cf. man zshexpn -> Modifiers)
ZSHRCDIR="${ZSHRC:h}"
# :A works like `realpath` (cf. man zshexpn -> Modifiers)
RSLV_ZSHRC="${ZSHRC:A}"
RSLV_ZSHRCDIR="${RSLV_ZSHRC:h}"

# aliases
if [ -f "${ZSHRCDIR}/.bash_aliases" ]; then
  source "${ZSHRCDIR}/.bash_aliases"
elif [ -f "${RSLV_ZSHRCDIR}/.bash_aliases" ]; then
  source "${RSLV_ZSHRCDIR}/.bash_aliases"
else
  echo "NOT FOUND: .bash_aliases" 1>&2
fi

# functions
if [ -f "${ZSHRCDIR}/.bash_funcs" ]; then
  source "${ZSHRCDIR}/.bash_funcs"
elif [ -f "${RSLV_ZSHRCDIR}/.bash_funcs" ]; then
  source "${RSLV_ZSHRCDIR}/.bash_funcs"
else
  echo "NOT FOUND: .bash_funcs" 1>&2
fi

if [ -f "${ZSHRCDIR}/.zsh_funcs" ]; then
  source "${ZSHRCDIR}/.zsh_funcs"
elif [ -f "${RSLV_ZSHRCDIR}/.zsh_funcs" ]; then
  source "${RSLV_ZSHRCDIR}/.zsh_funcs"
else
  echo "NOT FOUND: .zsh_funcs" 1>&2
fi

# show a startup message
startup_message "${ZSHUNIXTIME}"

# a terminal title
case "${TERM}" in
  xterm*)
    send_terminaltitle "${USER}@${HOSTNAME}"
    ;;
  putty*)
    send_terminaltitle "${USER}@${HOSTNAME} - PuTTY"
    ;;
esac

# complement settings
#   -U: do not expand aliases during autoload
#   -z: force zsh format
# cf. https://medium.com/@rukurx/ad471efd84c3
autoload -Uz compinit
if [ -z "${ZCOMPDUMP}" ]; then
  compinit
else
  compinit -d "${ZCOMPDUMP}"
fi

if [ -f "${ZSHRCDIR}/.zshcomp_sudovim" ]; then
  source "${ZSHRCDIR}/.zshcomp_sudovim"
elif [ -f "${RSLV_ZSHRCDIR}/.zshcomp_sudovim" ]; then
  source "${RSLV_ZSHRCDIR}/.zshcomp_sudovim"
else
  echo "NOT FOUND: .zshcomp_sudovim" 1>&2
fi

# do not beep when complement
setopt nolistbeep
# complement for --foo=bar
setopt magic_equal_subst
# disable switching complements
unsetopt auto_menu

# command histories
# share the history file with bash
export HISTFILE="${HOME}/.bash_history"
# the number of histories on RAM
export HISTSIZE=$((0x000FFFFF))
# the number of histories on HISTFILE
export SAVEHIST="${HISTSIZE}"
# appending mode (NOT overwriting)
setopt append_history
# ignore duplicate commands
setopt hist_ignore_dups
# ignore commands which start with whitespace
setopt hist_ignore_space
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
bindkey '^U'   backward-kill-line  # Ctrl-U
bindkey '^]'   vi-find-next-char   # Ctrl-]
bindkey '^[^]' vi-find-prev-char   # Meta-Ctrl-]
bindkey '^[%'  vi-match-bracket    # Meta-Shift-5 (or Meta-%)

# hooks
if [ -f "${ZSHRCDIR}/.zsh_hooks" ]; then
  source "${ZSHRCDIR}/.zsh_hooks"
elif [ -f "${RSLV_ZSHRCDIR}/.zsh_hooks" ]; then
  source "${RSLV_ZSHRCDIR}/.zsh_hooks"
else
  echo "NOT FOUND: .zsh_hooks" 1>&2
fi

# hook switches for git status
integer EXCLAMATIONMARK_GITRPROMPT=0
integer EXCLAMATIONMARK_GITCAPTION=0
integer QUESTIONMARK_GITRPROMPT=$((0xE2AB1E))
integer QUESTIONMARK_GITCAPTION=0
integer UNPREFERABLEHASH_GITRPROMPT=0
integer UNPREFERABLEHASH_GITCAPTION=0

# hook switches for a right prompt
integer ENABLE_RPROMPT=$((0xE2AB1E))
integer ENABLE_RPROMPT_GIT=$((0xCA5E))

# hook switches for screen
if [[ "${TERM}" = screen* ]]; then
  integer ENABLE_WINDOWTITLE=$((0xE2AB1E))
  integer ENABLE_PREX_GITCAPTION=$((0xE2AB1E))
  integer ENABLE_PREP_GITCAPTION=$((0xE2AB1E))

  # enable git status on caption only
  if [ "${ENABLE_PREP_GITCAPTION:-0}" -ne 0 ]; then
    ENABLE_RPROMPT_GIT=0
  fi
fi

# expand environment variables in prompts
setopt prompt_subst
# show a right prompt only on the current command line
setopt transient_rprompt

# prompt
function() {
  local p=
  p="$p%("            # if
  #                   #   %(X.---.---) means if %X then---else---fi
  p="$p?"             #   %?: the exit status of the previous command
  p="$p."             # then
  p="$p%F{green}"     #   start a color setting (green)
  p="$p."             # else
  p="$p%F{red}"       #   start a color setting (red)
  p="$p)"             # fi
  p="$p%n"            # a user name
  p="$p@"             # an at sign
  p="$p\${FORENAME}"  # a host name (instead of %m)
  p="$p:"             # a colon
  p="$p%~"            # the current directory
  p="$p%#"            # '#' if root, otherwise '%'
  p="$p "             # a whitespace
  p="$p%f"            # end a color setting
  PROMPT="$p"
}

# disable XON (Ctrl-Q) and XOFF (Ctrl-S) when interactive shells
# cf. https://linuxfan.info/disable-ctrl-s
if [ -t 0 ]; then
  stty start undef  # XON
  stty stop undef   # XOFF
fi

if [ -f "${HOME}/.zshrc.local" ]; then
  source "${HOME}/.zshrc.local"
fi
