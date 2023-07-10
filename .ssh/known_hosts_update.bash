#!/bin/bash
set -eu

sshdir="${HOME}/.ssh"
chmod +w "${sshdir}"/known_hosts
cat "${sshdir}"/hostkey_* > "${sshdir}"/known_hosts
chmod -w "${sshdir}"/known_hosts
