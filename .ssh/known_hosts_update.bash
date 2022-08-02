#!/bin/bash
set -e
chmod +w known_hosts
cat hostkey_* > known_hosts
chmod -w known_hosts
