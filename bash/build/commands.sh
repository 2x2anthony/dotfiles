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

    local CUR="$(pwd)"
    local success=0
    cd $DIR
    if [[ -f "$DIR/Build/build.sh" ]]; then
        # Bash.
        bash -c "$DIR/Build/build.sh"
        success=$?
    elif [[ -f "$DIR/Build/build.py" ]]; then
        # Python.
        python3 "$DIR/Build/build.py"
        success=$?
    else
        echo "Build directory found: $DIR/Build. Unknown build script."
        cd $CUR
        return 1
    fi

    cd $CUR
    return $success
}
