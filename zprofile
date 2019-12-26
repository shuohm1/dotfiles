# .zprofile

# is reboot required?
if [ -f /etc/redhat-release ]; then
  # RedHat / CentOS
  if [ -x "$(which needs-restarting 2> /dev/null)" ]; then
    needs-restarting -r | sed -e '1s/^/  * /' -e '2,$s/^/    /'
  fi
fi

if [ -f ~/.zprofile.local ]; then
  source ~/.zprofile.local
fi
