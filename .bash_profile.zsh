# .bash_profile.zsh

export REPLACE_BASH_WITH_ZSH="TRY"

# confirm this is bash, just in case
if [[ ! "$0" =~ (bash$) ]]; then
  # this is not bash, unexpectedly
  return
fi

# confirm this is a login shell, just in case
if [[ ! "$(shopt login_shell 2> /dev/null)" =~ (on$) ]]; then
  # not a login shell, unexpectedly
  return
fi

# which zsh
if [ ! -x "$(command which zsh 2> /dev/null)" ]; then
  return
fi

# check existence of zsh setting files
zfiles="OK"
for zfile in ".zshenv" ".zprofile" ".zshrc"; do
  if [ ! -f "${HOME}/${zfile}" ]; then
    zfiles="NG"
    break
  fi
done

if [ "${zfiles}" != "OK" ]; then
  unset zfiles
  return
fi

# now replace this bash with zsh
export REPLACE_BASH_WITH_ZSH="YES"
exec -l zsh
