#!/bin/bash
set -eu

g="$(command which git)"
test -x "$g"

gstatus="$($g status | tr 'A-Z' 'a-z')"
test -n "${gstatus}"

gbranch="$($g rev-parse --abbrev-ref HEAD 2> /dev/null || true)"
test -n "${gbranch}"
if [ "${gbranch}" = "HEAD" ]; then
  # try to get a commit ID instead of 'HEAD'
  gbranch="$($g rev-parse HEAD 2> /dev/null || true)"
fi

if [[ "${gstatus}" =~ (working (directory|tree) clean) ]]; then
  # green
  p="\e[32m${gbranch}\e[m: working tree clean"
elif [[ "${gstatus}" =~ (rebase in progress) ]]; then
  # fg: white, bg: red
  p="\e[37;41m${gbranch}\e[m: rebase in progress"
elif [[ "${gstatus}" =~ (changes not staged for commit) ]]; then
  # red
  p="\e[31m${gbranch}\e[m: there are changes not staged for commit"
elif [[ "${gstatus}" =~ (changes to be committed) ]]; then
  # yellow
  p="\e[33m${gbranch}\e[m: there are changes to be committed"
elif [[ "${gstatus}" =~ (untracked files) ]]; then
  # cyan
  p="\e[36m${gbranch}\e[m: there are untracked files"
else
  # fg: white, bg: blue
  p="\e[37;44m${gbranch}\e[m: unknown status"
fi

echo -e "You are on $p"
