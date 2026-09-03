# shellcheck shell=bash
#******************************************************************* Statusline
# If MONOREPO is set, skip git (avoids slow status in large repos)
precmd() {
  if [[ -n "$MONOREPO" ]]; then
    BRANCHY="???"
    CLEAN_BRANCH=""
  else
    BRANCHY=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a")
    BRANCHY="${BRANCHY/topic\/emcdow/t}"
    CLEAN_BRANCH=$([ -z "$(git status --porcelain)" ] || echo "\u001b[31m*") 2>/dev/null
  fi
  LEFT="\n\u001b[32;1m${USER}@$(hostname) \u001b[0m${CLEAN_BRANCH}\u001b[33m${BRANCHY}\u001b[0m:\u001b[34m${PWD/#$HOME/~}"
  RIGHT="$(date +'%H:%M:%S %m/%d/%y')"
  LEFT_NOCOLOR="$(echo "${LEFT}" | perl -pe 's/\e\[[0-9;]*m//g')"
  RIGHTWIDTH=$((COLUMNS - ${#LEFT_NOCOLOR}))
  printf '%b%*s\n' "$LEFT" "$RIGHTWIDTH" "$RIGHT"
}
PROMPT="%Bλ%b "
RPROMPT=""
# Reference so shellcheck sees use (zsh uses these for prompt display)
: "${PROMPT}" "${RPROMPT}"

#*************************************************************** Autocompletion
# Stolen from:
# https://dev.to/rossijonas/how-to-set-up-history-based-autocompletion-in-zsh-k7o

# initialize autocompletion
autoload -U compinit
compinit

# history setup
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
: "${SAVEHIST}"  # reference so shellcheck sees use (zsh uses for history)
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# GENERAL

# (bonus: Disable sound errors in Zsh)

# never beep
setopt NO_BEEP


#*************************************************************** Environment
OS=$( uname )
if [[ "$OS" == "Darwin" ]]; then
  . <( /opt/homebrew/bin/brew shellenv )
fi

# WORK: Prefer default profile's nix (2.28.x) over system profile (2.17.x) when using local profile
if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
  PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi
# WORK: Nix user profile
[[ -n "$HOME" && -d "$HOME/.nix-profile/bin" ]] && PATH="$HOME/.nix-profile/bin:$PATH"

# Node (add NPM global bin to PATH early)
PATH="$(npm get prefix -g)/bin:$PATH" 2>/dev/null
PATH="$HOME/.local/bin:$PATH"

# Go
PATH="$(go env GOPATH)/bin:$PATH" 2>/dev/null

# Rust
PATH="$HOME/.cargo/bin:$PATH"

# Zig (zvm)
PATH="$HOME/.zvm/bin:$HOME/.zvm/self:$PATH"

# Haskell
# shellcheck source=/dev/null
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# opt/apps/stuff from source
OPT_PATH=$(find "$HOME/apps" -maxdepth 1 -type d | xargs -I {} printf ':%s' {}) 2>/dev/null
PATH="$PATH:$OPT_PATH"

# Binutils (Mac only)
PATH="/usr/local/opt/binutils/bin:$PATH"

# Python
export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh 2>/dev/null)"

export PATH

# Ocaml
# shellcheck source=/dev/null
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null

#*************************************************************** Nice to have
function swap()
{
    local TMPFILE=tmp.$$
    mv "$1" "$TMPFILE" && mv "$2" "$1" && mv "$TMPFILE" "$2"
}

alias git-hot-refs="git branch --sort=committerdate | tail"

# Some distros (like omarchy) strangely install hx as 'helix'. This fixes that.
which hx >/dev/null || ( which helix >/dev/null && alias hx=helix )
