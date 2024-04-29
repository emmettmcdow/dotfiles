precmd() {
  BRANCHY=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a")
  LEFT="\n\u001b[32m${USER}@$(hostname) \u001b[33m${BRANCHY}\u001b[0m:\u001b[34m${PWD}"
  RIGHT="$(date)"
  LEFT_NOCOLOR="$(echo ${LEFT} | perl -pe 's/\e\[[0-9;]*m//g')"
  RIGHTWIDTH=$(($COLUMNS-${#LEFT_NOCOLOR}))
  print $LEFT${(l:$RIGHTWIDTH:: :)RIGHT}
}
PROMPT="$ "
RPROMPT=""
