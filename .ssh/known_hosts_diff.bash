#!/bin/bash
diffcmd=diff
[ -x "$(/bin/which colordiff 2> /dev/null)" ] && diffcmd=colordiff
${diffcmd} -u known_hosts <(cat hostkey_*)
