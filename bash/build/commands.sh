function build {
    local DIR="$(pwd)"
    local BUILD=""

    while [[ ! -d "$DIR/Build" ]]; do
        local TEMP=$DIR
        DIR=$(dirname "$DIR")
        if [[ $TEMP == $DIR ]]; then
            # We are as high in the directory tree as we can go.
            return 1
        fi
    done
    if [[ -f "$DIR/Build/build.sh" ]]; then
        # Bash.
        bash -c "$DIR/Build/build.sh"
    elif [[ -f "$DIR/Build/build.py" ]]; then
        # Python.
        python3 "$DIR/Build/build.py"
    else
        echo "Build directory found: $DIR/Build. Unknown build script."
        return 1
    fi

    return $?
}
