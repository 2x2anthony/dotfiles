function dev-yt {
    local SESSION_NAME="TmuxYtDevelopmentEnvironment";
    tmux has-session -t $SESSION_NAME;
    if [[ 0 != $? ]]; then
        tmux -f $TMUX_CONFIGURATION new-session -d -s $SESSION_NAME -n "YouTube Development Environment" -c "/work" "bash --init-file $DOTFILES_LOCATION/bash/environments/_dev-yt-environment.sh"
        exec tmux attach-session -t $SESSION_NAME;
    fi
}
