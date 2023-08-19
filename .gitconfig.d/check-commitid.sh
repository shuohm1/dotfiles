#!/bin/sh
set -eu

# git hooks for:
# * post-commit
# * post-merge
# * post-rewrite

if [ -z "$(git status 2> /dev/null)" ]; then
  exit 128
fi

logs="$(git log --oneline | command grep -i -E '^[df]e[a-z0-9]+' || true)"
if [ -z "${logs}" ]; then
  exit 0
fi

logs="$(
  echo "${logs}" |
  command sed -E 's/^([a-zA-Z0-9]+)/\x1b[30;41m\1\x1b[m/' |
  command sed 's/^/* /'
)"

echo "There are unpreferable commit hashes:"
echo "${logs}"

exit 1
