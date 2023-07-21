#!/bin/bash
set -eu

sshdir="${HOME}/.ssh"
chmod "u+w" "${sshdir}"/known_hosts
cat "${sshdir}"/hostkey_* > "${sshdir}"/known_hosts
chmod "a-w" "${sshdir}"/known_hosts
