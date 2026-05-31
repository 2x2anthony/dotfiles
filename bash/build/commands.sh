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
        success=1
    fi

    cd $CUR
    return $success
}

function update-zig {
    TARGET_DIR="$HOME/.software/zig";
    if [[ ! -d $TARGET_DIR ]]; then
        mkdir $TARGET_DIR;
    fi

    if [[ -f ~/.software/zig/zig_version.txt ]]; then
        CUR_VER=$(cat $TARGET_DIR/zig_version.txt);
    else
        CUR_VER="";
    fi

    ZIG_JSON=$(curl -s "https://ziglang.org/download/index.json");
    ZIG_VER=$(echo $ZIG_JSON | jq -r 'keys[]' | grep -vE 'master|dev|0.0.0' | sort -V | tail -n 1);

    if [[ "$CUR_VER" == "$ZIG_VER" ]]; then
        echo "Already on latest stable $CUR_VER.";
        return 0;
    fi

    # Clean old.
    rm -rf "$TARGET_DIR/*";

    echo $ZIG_VER > ~/.software/zig/zig_version.txt;
    read -r ZIG_URL ZIG_SHASUM < <(echo $ZIG_JSON | jq -r --arg v "$ZIG_VER" '.[$v]."x86_64-linux" | "\(.tarball) \(.shasum)"');
    echo $ZIG_URL
    echo $ZIG_SHASUM
    ZIG_FILE="zig-$ZIG_VER.tar.xz";
    curl -L0 "$ZIG_URL" -o $ZIG_FILE;
    echo "$ZIG_SHASUM $ZIG_FILE" | sha256sum --check;
    if [[ "$?" == "0" ]]; then
        tar -xvf $ZIG_FILE -C ~/.software/zig --strip-components=1;
    fi
    rm $ZIG_FILE;
}
