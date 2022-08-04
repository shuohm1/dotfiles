# .bash_profile

# is reboot required?
if [ -f /etc/redhat-release ]; then
  # RedHat / CentOS
  if [ -x "$(/bin/which needs-restarting 2> /dev/null)" ]; then
    needs-restarting -r | sed -e '1s/^/  * /' -e '2,$s/^/    /'
  fi
fi

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
