#!/bin/bash
shopt -s nocasematch

datadir="$(cd "$(dirname "$0")" && pwd)"
hiliter="$(which source-highlight 2> /dev/null)"

# check if a terminal can use more colors
escformat="esc"
if [[ "${TERM}" =~ 256color ]]; then
  escformat="esc256"
fi

# classical preprocessor
lessprep=cat
for filename in lesspipe lesspipe.sh; do
  filepath="$(which "${filename}" 2> /dev/null)"
  if [ -x "${filepath}" ]; then
    lessprep="${filepath}"
    break
  fi
done

# from `man lesspipe`
extensions="$(cat <<EOS
         *.a
         *.arj
         *.tar.bz2
         *.bz
         *.bz2
         *.deb, *.udeb, *.ddeb
         *.doc
         *.gif, *.jpeg, *.jpg, *.pcd, *.png, *.tga, *.tiff, *.tif
         *.iso, *.raw, *.bin
         *.lha, *.lzh
         *.tar.lz, *.tlz
         *.lz
         *.7z
         *.pdf
         *.rar, *.r[0-9][0-9]
         *.rpm
         *.tar.gz, *.tgz, *.tar.z, *.tar.dz
         *.gz, *.z, *.dz
         *.tar
         *.tar.xz, *.xz
         *.jar, *.war, *.xpi, *.zip
         *.zoo
EOS
)"
# convert extensions into a bar-separated format: foo|bar|baz
extensions="$(echo "${extensions}" |
  tr '\n' ' ' |
  sed -E 's/ +/ /g; s/,|^ +| +$//g; s/\*[^ ]*\.//g' |
  tr ' ' '|'
)"

for filepath in "$@"; do
  # if file is extractable or the highlighter is not available
  extractable="$(echo "${filepath}" | grep -i -E "\.(${extensions})\$")"
  if [ -n "${extractable}" -o ! -x "${hiliter}" ]; then
    "${lessprep}" "${filepath}"
    continue
  fi

  # determine the highlighting language
  if [[ "${_LESSLANG:-auto}" =~ ^(auto|infer)$ ]]; then
    filename="$(basename "${filepath}")"
    if [[ "${filename}" == "changelog" ]]; then
      langopt="--lang-def=changelog.lang"
    elif [[ "${filename}" =~ ^makefile ]]; then
      langopt="--lang-def=makefile.lang"
    else
      langopt="--infer-lang"
    fi
  elif [[ "${_LESSLANG}" =~ ^(no|none|off)$ ]]; then
    langopt="--lang-def=nohilite.lang"
  else
    langopt="--lang-def=${_LESSLANG}.lang"
  fi

  "${hiliter}" ${langopt} --failsafe                \
    --input="${filepath}"                           \
    --out-format=${escformat}                       \
    --outlang-def="${datadir}/${escformat}.outlang" \
    --style-file="${datadir}/${escformat}.style"
done
