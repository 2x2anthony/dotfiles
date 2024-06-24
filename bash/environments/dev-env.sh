function dev-env {
    local SESSION_NAME="TmuxDevelopmentEnvironment"
    tmux has-session -t $SESSION_NAME
    if [[ 0 != $? ]]; then
        tmux -f $TMUX_CONFIGURATION new-session -t $SESSION_NAME -c "/work"
        exec tmux attach-session -t $SESSION_NAME
    fi
}
