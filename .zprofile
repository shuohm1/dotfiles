# .zprofile

# is reboot required?
if [ -f /etc/redhat-release ]; then
  # RedHat / CentOS
  if [ -x "$(which needs-restarting 2> /dev/null)" ]; then
    needs-restarting -r | sed -e '1s/^/  * /' -e '2,$s/^/    /'
  fi
fi

# tmp
if [ ! -e "${HOME}/tmp" -a -d "/run/user/$(id -u)" ]; then
  ln -s "/run/user/$(id -u)" "${HOME}/tmp" 2> /dev/null
fi

# local settings
if [ -f "${HOME}/.zprofile.local" ]; then
  source "${HOME}/.zprofile.local"
fi
