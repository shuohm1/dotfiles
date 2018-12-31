# .zshenv

if [ -f ~/.bashrc.env ]; then
  source ~/.bashrc.env
fi

# set the current shell's path again
set_shpath "$0"

if [ -f ~/.zshenv.local ]; then
  source ~/.zshenv.local
fi
