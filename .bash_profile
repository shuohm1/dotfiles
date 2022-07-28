# .bash_profile

# is reboot required?
if [ -f /etc/redhat-release ]; then
  # RedHat / CentOS
  if [ -x "$(which needs-restarting 2> /dev/null)" ]; then
    needs-restarting -r | sed -e '1s/^/  * /' -e '2,$s/^/    /'
  fi
fi

if [ -f "${HOME}/.bash_profile.local" ]; then
  source "${HOME}/.bash_profile.local"
fi

if [ -f "${HOME}/.bashrc" ]; then
  source "${HOME}/.bashrc"
fi
