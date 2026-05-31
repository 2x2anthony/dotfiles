function dev-env {
    local SESSION_NAME="TmuxDevelopmentEnvironment"
    tmux has-session -t $SESSION_NAME
    if [[ 0 != $? ]]; then
        export PATH=$PATH:$HOME/.software/zig;
        tmux -f $TMUX_CONFIGURATION new-session -t $SESSION_NAME -c "/work"
    fi
    exec tmux attach-session -t $SESSION_NAME
}
