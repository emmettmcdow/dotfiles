#!/usr/bin/env bash

export packages=( \
  "go" \
  "gopls" \
  "dlv" \
  "hx" \
  "python3" \
  "git" \
  "make" \
  "tar" \
  "zsh"
)

function healthcheck() {

  # Make sure to update the width if we get a program gets too long
  for p in "${packages[@]}"; do
    which "$p" &>/dev/null
    if [ "$?" ]; then
      printf "%-8s   \033[32m%s\033[39m\n" "$p" "✓"
    else
      printf "%-8s    \033[31m%s\033[39m\n" "$p" "✗"
    fi  
  done

}

healthcheck
