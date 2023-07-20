#!/bin/bash
# usage: ln -s lesswrapper.bash less
set -eu

mypath="$(readlink -e "$0" 2> /dev/null)"
myname="$(basename "${mypath}")"

lesscmd="$(
  command which -a less 2> /dev/null |
  # canonicalize paths
  xargs readlink -e 2> /dev/null |
  # get the top command except this script itself
  command grep -v -F "${mypath}" | head -n 1
)"

if [ ! -x "${lesscmd}" ]; then
  echo "${myname}: fatal: command not found: less" 1>&2
  exit 127
fi

# reset
status=0
export _LESSLANG=
trap 'status=$?; export _LESSLANG=; exit $status' INT PIPE TERM

# reconstruct arguments
declare -a lessargs=("${lesscmd}")
for arg in "$@"; do
  if [[ "${arg}" =~ ^--lang= ]]; then
    export _LESSLANG="${arg#*=}"
    if [[ "${_LESSLANG}" =~ ^(no|none|off)$ ]]; then
      # ignore LESSOPEN
      lessargs+=("--no-lessopen")
    fi
  else
    lessargs+=("${arg}")
  fi
done

if [ -t 0 ]; then
  # stdin is a terminal
  "${lessargs[@]}"
  status=$?
elif [ -f /dev/stdin ]; then
  # stdin is redirected
  "${lessargs[@]}" < /dev/stdin
  status=$?
elif [ -p /dev/stdin ]; then
  # stdin is piped
  cat /dev/stdin | "${lessargs[@]}"
  status=$?
else
  # other
  echo "${myname}: error: unknown input type" 1>&2
  status=1
fi

export _LESSLANG=
exit $status
