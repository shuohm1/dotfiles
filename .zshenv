# .zshenv

if [ -f "${HOME}/.bashrc.env" ]; then
  source "${HOME}/.bashrc.env"
fi

if [ -f "${HOME}/.zshenv.local" ]; then
  source "${HOME}/.zshenv.local"
fi
