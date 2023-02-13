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
		echo "failed to install zsh, exiting"
		return 1
	fi

	sudo $PM install -y zsh || echo "failed to install zsh, exiting" && return 1
	sudo chsh -s $(which zsh) $USER
	return 0
}

function assertOHMY() {
	# Check for oh-my-zsh
  [ -d "$HOME/.oh-my-zsh" ] && return 0

	# Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && return 0

	# Failed
	echo "failed to install oh-my-zsh, exiting"
	return 1
}

function assertPyEnv() {
	# Check for PyEnv
	which pyenv && return 0
  
	# Install PyEnv
	bash -c "$(curl https://pyenv.run)" && return 0
	
	# Failed
	echo "failed to install pyenv, exiting"
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
		assertZSH && assertOHMY && assertPyEnv && doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		assertZSH && assertOHMY && assertPyEnv && doIt;
	fi;
fi;
unset doIt;
