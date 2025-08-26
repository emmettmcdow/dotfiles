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
        -avh --no-perms ~/.config .;
    echo ".config updated. Now commit and push your changes."
}

updateThis;
unset doIt;
