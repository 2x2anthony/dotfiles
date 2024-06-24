# Always use the config file located in $DOTFILES_LOCATION/nvim/init.lua
# instead of using ~/.config/nvim/init.lua
alias nvim="nvim -u $DOTFILES_LOCATION/nvim/init.lua"

# Always enforce that aerc uses the custom configuration file located in
# $DOTFILES_LOCATION/aerc/aerc.conf
alias aerc="aerc --aerc-conf $DOTFILES_LOCATION/aerc/aerc.conf"
