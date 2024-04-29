
function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude "Dockerfile" \
        -avh --no-perms . ~;

    [[ $SHELL == `which zsh` ]] && source ~/.zshrc

    echo "Checks done and sync completed, make sure you run zsh and source .zshrc, and run :PlugInstall inside vim"
}

# "Main" function
cd "$(dirname "${BASH_SOURCE}")";
git pull origin main &>/dev/null;

if [ "$1" == "--force" -o "$1" == "-f" ]; then
        doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
