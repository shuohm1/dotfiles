# .zshenv

if [[ -d "${ZDOTDIR}" && -f "${ZDOTDIR}/.bashrc.env" ]]; then
  source "${ZDOTDIR}/.bashrc.env"
else
  source "${HOME}/.bashrc.env"
fi

# make $SECONDS a double type (cf. man zshparam)
float -F6 SECONDS

# get a UNIX time when this zsh process is started
float -F6 ZSHUNIXTIME="NaN"

function() {
  local unixtime="%D{%s.%9.}"
  float -F6 sec1="${SECONDS}"
  float -F9 curr="${(%)unixtime}"
  float -F6 sec2="${SECONDS}"
  (( ZSHUNIXTIME = curr - (sec1 + sec2) / 2.0 ))
}

if [ $(( ZSHUNIXTIME != ZSHUNIXTIME )) -ne 0 ]; then
  # ZSHUNIXTIME is NaN
  unset ZSHUNIXTIME
fi

if [[ -d "${ZDOTDIR}" && -f "${ZDOTDIR}/.zshenv.local" ]]; then
  source "${ZDOTDIR}/.zshenv.local"
elif [ -f "${HOME}/.zshenv.local" ]; then
  source "${HOME}/.zshenv.local"
fi
