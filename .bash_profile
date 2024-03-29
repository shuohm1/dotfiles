# .bash_profile

# temporary directories
function make_temporary_directory() {
  local p="$(readlink -f "$1" 2> /dev/null)"
  if [ ! -e "$p" ]; then
    mkdir -m "a=-st,u=rwx" "$p"
  elif [ -d "$p" ]; then
    chmod "a=-st,u=rwx" "$p"
  fi
}

make_temporary_directory "${HOME}/tmp"
make_temporary_directory "${HOME}/.cache"
make_temporary_directory "${HOME}/tmp/.vimswap"

# local settings
if [ -f "${HOME}/.bash_profile.local" ]; then
  source "${HOME}/.bash_profile.local"
fi

# replace login bash with zsh
if [ -f "${HOME}/.bash_profile.zsh" ]; then
  source "${HOME}/.bash_profile.zsh"
fi

# to be continued
source "${HOME}/.bashrc"
