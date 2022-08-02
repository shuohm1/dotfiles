#!/bin/bash
diffcmd=diff
[ -x "$(which colordiff 2> /dev/null)" ] && diffcmd=colordiff
${diffcmd} -s -u known_hosts <(cat hostkey_*)
