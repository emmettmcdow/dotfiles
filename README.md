# Things you should probably install first
1. zsh
2. git
3. helix editor
4. rsync

Then clone this repo to `~/dotfiles` and run `.local/bin/synchome` to copy it
over your home directory. Everything in `.local/bin` lands on your `PATH`, so
after the first sync the helpers below are available as plain commands.

# Helpers
- `synchome` — copy this repo over `$HOME`. Prompts first; `-f`/`--force` skips.
- `syncdot` — copy the live config out of `$HOME` back into this repo to commit.
- `depcheck` — report which expected tools are missing from `PATH`.
- `git-hot-refs` — the branches with the most recent commits (`git hot-refs`).
- `passgen` — print a random password.

`synchome` and `syncdot` assume the repo is at `~/dotfiles`; set `DOTFILES` to
point them elsewhere.

# Things Emmett would like to install

> TODO: add a script to do this

1. `go install golang.org/x/tools/gopls@latest`
2. `go install github.com/go-delve/delve/cmd/dlv@latest`
