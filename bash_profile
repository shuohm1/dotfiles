# .bash_profile

if [ -f ~/.bash_profile.local ]; then
  source ~/.bash_profile.local
fi

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# terminal title
printf "\033]0;${USER}@${HOSTNAME}\007"
