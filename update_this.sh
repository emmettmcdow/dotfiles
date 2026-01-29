#!/usr/bin/env bash

function updateThis() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude "Dockerfile" \
        --exclude "runtime" \
        --exclude ".config/alacritty" \
        -avh --no-perms ~/.config ~/.ignore ~/.zshrc .;
    echo ".config updated. Now commit and push your changes."
}

updateThis;
unset doIt;
