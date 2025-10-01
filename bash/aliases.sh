# Always use the config file located in $DOTFILES_LOCATION/nvim/init.lua
# instead of using ~/.config/nvim/init.lua
alias nvim="nvim -u $DOTFILES_LOCATION/nvim/init.lua"

# Always enforce that aerc uses the custom configuration file located in
# $DOTFILES_LOCATION/aerc/aerc.conf
alias aerc="aerc --aerc-conf $DOTFILES_LOCATION/aerc/aerc.conf --binds-conf $DOTFILES_LOCATION/aerc/binds.conf"

# Python3 is installed by default on new Linux distros, and it needs to be used as default.
alias python="python3"

# Enable extra tools to be utilized that shouldn't require root.
export PATH=$PATH:/work/tools

