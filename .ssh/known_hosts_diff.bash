#!/bin/bash
diffcmd=diff
if [ -x "$($(command which which) colordiff 2> /dev/null)" ]; then
  diffcmd=colordiff
fi
${diffcmd} -u known_hosts <(cat hostkey_*)
