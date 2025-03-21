
#******************************************************************* Statusline
precmd() {
  BRANCHY=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a")
  CLEAN_BRANCH=$([ -z "$(git status --porcelain)" ] || echo "\u001b[31m*") 2>/dev/null
  LEFT="\n\u001b[32;1m${USER}@$(hostname) \u001b[0m${CLEAN_BRANCH}\u001b[33m${BRANCHY}\u001b[0m:\u001b[34m${PWD}"
  RIGHT="$(date)"
  LEFT_NOCOLOR="$(echo ${LEFT} | perl -pe 's/\e\[[0-9;]*m//g')"
  RIGHTWIDTH=$(($COLUMNS-${#LEFT_NOCOLOR}))
  print $LEFT${(l:$RIGHTWIDTH:: :)RIGHT}
}
PROMPT="%Bλ%b "
RPROMPT=""

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
PATH="$(go env GOPATH)/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
# aka haskell
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# opt/apps/stuff from source
PATH="$PATH$(find $HOME/apps -depth 1 -type d | xargs -I {} printf ':%s' {})"

# Node
PATH="$PATH:$(npm get prefix -g)/bin"
export PATH

# Ocaml
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null

# This is mac only, shouldn't hurt anything though?
echo 'export PATH="/usr/local/opt/binutils/bin:$PATH"' >> ~/.zshrc

#*************************************************************** Nice to have
function swap()         
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}
