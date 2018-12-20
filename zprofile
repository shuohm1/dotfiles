# .zprofile

if [ -f ~/.zprofile.local ]; then
  source ~/.zprofile.local
fi

# terminal title
printf "\033]0;${USER}@${HOSTNAME}\007"
