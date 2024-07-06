
function _DEFAULT_ENVIRONMENT_ {
    local TMUX_SESSION_NAME="TmuxDefaultEnvironment"

    if [[ "$EUID" -eq 0 ]]; then
        # Do not run this environment in a root terminal
        return 0
    fi

    tmux has-session -t $TMUX_SESSION_NAME
    if [[ $? != 0 ]]; then
        tmux -f $TMUX_CONFIGURATION new-session -d -t $TMUX_SESSION_NAME
        tmux rename-window -t $TMUX_SESSION_NAME "Email"
        tmux send-keys -t $TMUX_SESSION_NAME aerc C-m
        tmux new-window -t $TMUX_SESSION_NAME -n Mastodon
        tmux send-keys -t $TMUX_SESSION_NAME "toot tui" C-m
        tmux new-window -t $TMUX_SESSION_NAME -n Monitoring
        tmux send-keys -t $TMUX_SESSION_NAME "btop" C-m
        tmux new-window -t $TMUX_SESSION_NAME -n IRC
        tmux send-keys -t $TMUX_SESSION_NAME irssi C-m
        tmux select-window -t $TMUX_SESSION_NAME:0
        exec tmux attach-session -t $TMUX_SESSION_NAME
    fi
}

_DEFAULT_ENVIRONMENT_
