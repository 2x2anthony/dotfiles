function dev-esp {
    local ESP_SESSION_NAME="TmuxEspDevelopmentEnvironment"
    tmux has-session -t $ESP_SESSION_NAME 2>&1 >/dev/null
    if [[ 0 != $? ]]; then
        tmux -f $TMUX_CONFIGURATION new-session -d -s $ESP_SESSION_NAME -n "ESP-IDF Environment" -c "/work/embedded" "bash --init-file $DOTFILES_LOCATION/bash/environments/_dev-esp-environment.sh"
        exec tmux attach-session -t $ESP_SESSION_NAME
    fi
}
