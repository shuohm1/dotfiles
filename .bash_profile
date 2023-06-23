# .bash_profile

# tmp
if [[ ! -e "${HOME}/tmp" && -d "/run/user/$(id -u)" ]]; then
  ln -s "/run/user/$(id -u)" "${HOME}/tmp" 2> /dev/null
fi

# local settings
if [ -f "${HOME}/.bash_profile.local" ]; then
  source "${HOME}/.bash_profile.local"
fi

# to be continued
if [ -f "${HOME}/.bashrc" ]; then
  source "${HOME}/.bashrc"
fi
