#!/bin/bash
set -eu

diffcmd=diff
if [ -x "$($(command which which) colordiff 2> /dev/null)" ]; then
  diffcmd=colordiff
fi

sshdir="${HOME}/.ssh"
${diffcmd} -u "${sshdir}"/known_hosts <(cat "${sshdir}"/hostkey_*)
