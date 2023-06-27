# .zprofile

# tmp
if [[ ! -e "${HOME}/tmp" && -d "/run/user/$(id -u)" ]]; then
  ln -s "/run/user/$(id -u)" "${HOME}/tmp" 2> /dev/null
fi

# local settings
if [ -f "${HOME}/.zprofile.local" ]; then
  source "${HOME}/.zprofile.local"
fi
