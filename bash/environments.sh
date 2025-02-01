# Default tmux configuration
export TMUX_CONFIGURATION=$DOTFILES_LOCATION/tmux/tmux.conf

# Automatic environment for the very first terminal opened
source $DOTFILES_LOCATION/bash/environments/default-env.sh

# Development environment
source $DOTFILES_LOCATION/bash/environments/dev-env.sh

# ESP Development environment
source $DOTFILES_LOCATION/bash/environments/dev-esp.sh

