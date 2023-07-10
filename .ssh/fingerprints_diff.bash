#!/bin/bash
set -eu
[ $# -eq 0 ] && exit 0

diffcmd=diff
if [ -x "$($(command which which) colordiff 2> /dev/null)" ]; then
  diffcmd=colordiff
fi

${diffcmd} -u <(cat "$@" | grep 'SHA256:' | sed 's/^# //') <(cat "$@" | ssh-keygen -l -f -)
