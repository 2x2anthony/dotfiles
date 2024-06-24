# The location for all of this
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup ~/.bash_aliases
function _install_bash {
    local dotfilesLocation="export DOTFILES_LOCATION=\"$SCRIPT_DIR\""
    local bashAliasesLocation="source $SCRIPT_DIR/bash/bash_aliases.sh"

    if [[ ! -f ~/.bash_aliases ]]; then
        touch ~/.bash_aliases
    fi

    echo "Installing ~/.bash_aliases..."
    echo $dotfilesLocation >> ~/.bash_aliases
    echo $bashAliasesLocation >> ~/.bash_aliases

    # Source the file so that everything is immediately accessible
    source ~/.bash_aliases
}

function run {
    _install_bash
}

# Run the installation.
run;
