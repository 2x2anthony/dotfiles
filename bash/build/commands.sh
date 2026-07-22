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
    local TARGET_DIR="$HOME/.software/zig";
    if [[ ! -d $TARGET_DIR ]]; then
        mkdir $TARGET_DIR;
    fi

    if [[ -f ~/.software/zig/zig_version.txt ]]; then
        local CUR_VER=$(cat $TARGET_DIR/zig_version.txt);
    else
        local CUR_VER="";
    fi

    local ZIG_JSON=$(curl -s "https://ziglang.org/download/index.json");
    local ZIG_VER=$(echo $ZIG_JSON | jq -r 'keys[]' | grep -vE 'master|dev|0.0.0' | sort -V | tail -n 1);

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
    local ZIG_FILE="zig-$ZIG_VER.tar.xz";
    curl -L0 "$ZIG_URL" -o $ZIG_FILE;
    echo "$ZIG_SHASUM $ZIG_FILE" | sha256sum --check;
    if [[ "$?" == "0" ]]; then
        tar -xvf $ZIG_FILE -C ~/.software/zig --strip-components=1;
    fi
    rm $ZIG_FILE;
}

function update-nvim {
    local TARGET_DIR="$HOME/.software/nvim";
    if [[ ! -d $TARGET_DIR ]]; then
        mkdir $TARGET_DIR;
    fi

    if [[ -f "$TARGET_DIR/nvim_version.txt" ]]; then
        local CUR_VER=$(cat "$TARGET_DIR/nvim_version.txt");
    else
        local CUR_VER="";
    fi

    local NVIM_JSON=$(curl -s "https://api.github.com/repos/neovim/neovim/releases");

    local LATEST_STABLE=$(echo "$NVIM_JSON" | jq -r '
    [.[] | select(.draft == false and .prerelease == false)] 
    | first 
    ');

    local NVIM_ASSET=$(echo "$LATEST_STABLE" | jq -r '
    .assets[] 
    | select(.name | contains("linux-x86_64") and endswith(".tar.gz")) 
    ');

    local DOWNLOAD_URL=$(echo "$NVIM_ASSET" | jq -r '.browser_download_url');
    local DOWNLOAD_SHASUM=$(echo "$NVIM_ASSET" | jq -r '.digest');

    local NEWEST_VERSION=$(echo "$LATEST_STABLE" | jq -r '.tag_name');

    if [[ "$CUR_VER" == "$NEWEST_VERSION" ]]; then
        echo "Already on latest stable $CUR_VER";
        return 0;
    fi

    # Clean old.
    rm -rf "$TARGET_DIR/*";

    echo $NEWEST_VERSION > "$TARGET_DIR/nvim_version.txt";
    echo $DOWNLOAD_URL;
    echo $DOWNLOAD_SHASUM;

    local NVIM_FILE="nvim-$NEWEST_VERSION.tar.gz"
    curl -L0 "$DOWNLOAD_URL" -o $NVIM_FILE;
    echo "${DOWNLOAD_SHASUM#sha256:}  $NVIM_FILE" | sha256sum --check;

    if [[ "$?" == "0" ]]; then
        tar -xvf $NVIM_FILE -C ~/.software/nvim --strip-components=1;
    else
        # SHA failed, no version installed anymore.
        rm "$TARGET_DIR/nvim_version.txt";
    fi

    rm $NVIM_FILE;
}
