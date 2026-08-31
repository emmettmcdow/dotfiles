#!/usr/bin/env bash

function updateThis() {
    rsync --exclude-from="syncexclude" --cvs-exclude -avh --no-perms ~/.config ~/.ignore ~/.zshrc .;
    echo ".config updated. Now commit and push your changes."
}

updateThis;
