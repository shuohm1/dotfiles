# .bash_profile

# is reboot required?
if [ -f /etc/redhat-release ]; then
  # RedHat / CentOS
  if [ -x "$(which needs-restarting 2> /dev/null)" ]; then
    needs-restarting -r | sed -e '1s/^/  * /' -e '2,$s/^/    /'
  fi
fi

if [ -f ~/.bash_profile.local ]; then
  source ~/.bash_profile.local
fi

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
