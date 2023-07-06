# .bash_profile

# local settings
if [ -f "${HOME}/.bash_profile.local" ]; then
  source "${HOME}/.bash_profile.local"
fi

# to be continued
if [ -f "${HOME}/.bashrc" ]; then
  source "${HOME}/.bashrc"
fi
