export VIMINIT="source ~/.vim/vimrc"

# EDITOR points at the wrapper rather than at `hx` directly so that it still
# resolves on machines where the binary is named `helix`. The path is absolute
# because PATH is not fully built yet: on macOS /etc/zprofile runs path_helper
# (which adds /opt/homebrew/bin) only *after* this file, so `command -v hx`
# here would come up empty even when helix is installed.
if [ -x "$HOME/.local/bin/editor" ]; then
    export EDITOR="$HOME/.local/bin/editor"
else
    export EDITOR=hx
fi
