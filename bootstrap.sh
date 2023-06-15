#!/usr/bin/env bash

function packageManager() {
    which dnf &>/dev/null && PM='dnf' && return 0
    which yum &>/dev/null && PM='yum' && return 0
    which apt &>/dev/null && PM='apt' && return 0
    which brew &>/dev/null && PM='brew' && return 0
    return 1
}

function assertZSH() {
    echo "---"
    which zsh &>/dev/null && echo "✅ - zsh present" && return 0

    echo "❌ - zsh not present, attempting to install"
    if ! packageManager; then
        echo "failed to install zsh, exiting"
        return 1
    fi

    if sudo $PM install -y zsh  &>/dev/null ; then
        echo "✅ - zsh installed"
        return 0
    else
        echo "failed to install zsh, exiting"
        return 1
    fi
}

function assertccls() {
    echo "---"
    which ccls &>/dev/null && echo "✅ - ccls present" && return 0

    echo "❌ - ccls not present, attempting to install"
    if ! packageManager; then
        echo "failed to install zsh, exiting"
        return 1
    fi

    if sudo $PM install -y ccls  &>/dev/null ; then
        echo "✅ - ccls installed"
        return 0
    else
        echo "failed to install ccls, exiting"
        return 1
    fi
}

function assertOHMY() {
    # Check for oh-my-zsh
    echo "---"
    [ -d "$HOME/.oh-my-zsh" ] && echo "✅ - oh-my-zsh present" && return 0

    echo "❌ - oh-my-zsh not present, attempting to install"
    # Install oh-my-zsh
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh
    chmod +x install.sh
    zsh -c "export SHELL=`which zsh`;export RUNZSH=no; . ./install.sh &>/dev/null" &>/dev/null && rm install.sh && echo "✅ - oh-my-zsh installed" && return 0

    rm install.sh
    # Failed
    echo "failed to install oh-my-zsh, exiting"
    return 1
}

function assertPyEnv() {
    echo "---"
    # Check for PyEnv
    [ -d $HOME/.pyenv ] && echo "✅ - PyEnv present" && return 0


    echo "❌ - PyEnv not present, attempting to install"
    # Install PyEnv
    curl -fsSL https://pyenv.run > install.sh
    chmod +x install.sh
    bash -c ". ./install.sh &>/dev/null" &>/dev/null && rm install.sh && echo "✅ - PyEnv installed" && return 0

    rm install.sh
    # Failed
    echo "failed to install pyenv, exiting"
    return 1

}

function assertNode() {
    # This is a dependency for some vim plugins
    echo "---"
    which node &>/dev/null && echo "✅ - Node present" && return 0

    echo "❌ - Node not present, attempting to install"
    case $PM in
        dnf)
            sudo dnf module install -y nodejs:20/common &>/dev/null || echo "failed to install node, exiting"

        ;;
        yum)
            sudo yum module install -y nodejs:20/common &>/dev/null || echo "failed to install node, exiting"

        ;;
        apt)
            sudo apt install -y nodejs  &>/dev/null || echo "failed to install node, exiting"
        ;;
        brew)
            brew install nodejs -y &>/dev/null || echo "failed to install node, exiting"
        ;;
        *)
            echo "could not install node, exiting"
        ;;
    esac
    which node &> /dev/null || return 1
    echo "✅ - Node Installed"
    return 0
}

function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude "Dockerfile" \
        -avh --no-perms . ~;

    sed -ie 's^"clangd.path": .*"^"clangd.path": '\"$(which clangd)\"'^g' ~/.vim/coc-settings.json
    sed -ie 's^"python.path": .*"^"python.pythonPath": '\"$(which python3)\"'^g' ~/.vim/coc-settings.json
    [[ $SHELL == `which zsh` ]] && source ~/.zshrc

    echo "Checks done and sync completed, make sure you run zsh and source .zshrc, and run :PlugInstall inside vim"
}

#TODO: add dependency on the_silver_searcher
# "Main" function
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main &>/dev/null;

if [ "$1" == "--force" -o "$1" == "-f" ]; then
        assertZSH && assertOHMY && assertPyEnv && assertNode && assertccls && doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        assertZSH && assertOHMY && assertPyEnv && assertNode && assertccls && doIt;
    fi;
fi;
unset doIt;
