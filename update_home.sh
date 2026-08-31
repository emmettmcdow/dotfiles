#!/usr/bin/env bash

function updateHome() {
    rsync --exclude-from="syncexclude" --cvs-exclude -avh --no-perms . ~;
    echo "Checks done and sync completed, make sure you run zsh and source .zshrc."
}

# "Main" function
git pull origin main &>/dev/null;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
        updateHome;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        updateHome;
    fi;
fi;
