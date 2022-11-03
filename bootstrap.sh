#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function packageManager() {
	which dnf && PM='dnf' && return 0
	which yum && PM='yum' && return 0
	which apt && PM='apt' && return 0
	which brew && PM='brew' && return 0
	return 1
}

function assertZSH() {
	which zsh && return 0
	
	if packageManager; then
		echo "You will be asked to input your sudo password"
	else
		return 1
	fi

	$("sudo ${PM} install -y zsh") && return 0
	sudo chsh -s $(which zsh) $USER
	return 1
}

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.zshrc;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	assertZSH && doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		asserZSH && doIt;
	fi;
fi;
unset doIt;
