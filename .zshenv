# .zshenv

if [[ -d "${ZDOTDIR}" && -f "${ZDOTDIR}/.bashrc.env" ]]; then
  source "${ZDOTDIR}/.bashrc.env"
else
  source "${HOME}/.bashrc.env"
fi

if [[ -d "${ZDOTDIR}" && -f "${ZDOTDIR}/.zshenv.local" ]]; then
  source "${ZDOTDIR}/.zshenv.local"
elif [ -f "${HOME}/.zshenv.local" ]; then
  source "${HOME}/.zshenv.local"
fi
