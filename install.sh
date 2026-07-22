# The location for all of this
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ESP_IDF_VER="v5.4"

function _is_apt {
    command -v apt 2>&1 >/dev/null
    return $?
}

function _apt_or_yum {
    if [[ ! $(_is_apt) ]]; then
        sudo yum -y update && sudo yum install "$@"
    else
        sudo apt-get install "$@"
    fi
}

# Setup ~/.bash_aliases
function _install_bash {
    local dotfilesLocation="export DOTFILES_LOCATION=\"$SCRIPT_DIR\""
    local bashAliasesLocation="source $SCRIPT_DIR/bash/bash_aliases.sh"
    local espIdfVersion="export ESP_IDF_VER=\"$ESP_IDF_VER\""

    if [[ ! -f ~/.bash_aliases ]]; then
        touch ~/.bash_aliases
    fi

    echo "Installing ~/.bash_aliases..."
    echo $dotfilesLocation >> ~/.bash_aliases
    echo $espIdfVersion >> ~/.bash_aliases
    echo $bashAliasesLocation >> ~/.bash_aliases

    # Source the file so that everything is immediately accessible
    source ~/.bash_aliases
}

function _install_env_vars {
    if [[ ! -d ~/.config/environment.d ]]; then
        mkdir -p ~/.config/environment.d
    fi

    local envFile="$HOME/.config/environment.d/10-env.conf"

    if [[ ! -f $envFile ]]; then
        touch $envFile
    fi

    echo "DOTFILES_LOCATION=\"$SCRIPT_DIR\"" >> $envFile
    echo "ESP_IDF_VER=\"$ESP_IDF_VER\"" >> $envFile
}

function _setup_work_environment {
    if [[ ! -d "/work" ]]; then
        local USER=$(whoami)
        sudo mkdir /work
        sudo chown $USER:$USER /work
    fi

    if [[ ! -d "/work/embedded" ]]; then
        mkdir /work/embedded
    fi

    if [[ ! -d "/work/tools" ]]; then
        mkdir /work/tools
    fi
}

function _install_esp_dev_environment {
    git clone -b $ESP_IDF_VER --recursive https://github.com/espressif/esp-idf.git /work/SDKs/esp-idf-$ESP_IDF_VER
    _apt_or_yum wget flex bison gperf python3 cmake ninja-build ccache dfu-util
    if [[ $(_is_apt) ]]; then
        # Ubuntu
        _apt_or_yum python3-pip python3-env libffi-dev libssl-dev libusb-1.0-0
    else
        # Not Ubuntu, but another popular platform that uses yum. Maybe I should check for pacman
        # next?
        _apt_or_yum libusbx
    fi

    bash -c "cd /work/SDKs/esp-idf-$ESP_IDF_VER; ./install.sh esp32c2"
}

function _install_latest_stable_zig {
    if [[ ! -d ~/.software/zig ]]; then
        mkdir ~/.software/zig;
    fi

    ZIG_JSON=$(curl -s "https://ziglang.org/download/index.json");
    ZIG_VER=$(echo $ZIG_JSON | jq -r 'keys[]' | grep -vE 'master|dev|0.0.0' | sort -V | tail -n 1);
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

function _install_latest_stable_nvim {
    local TARGET_DIR="$HOME/.software/nvim";
    if [[ ! -d $TARGET_DIR ]]; then
        mkdir $TARGET_DIR;
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

function _setup_nvim {
    # If this repository was not initialised with --recurse-submodules
    # then the submodules have not been downloaded.
    echo "Updating neovim plugins and themes..."
    git submodule update --remote --recursive --init
}

function run {
    _setup_work_environment
    _install_bash
    _setup_nvim
    _install_env_vars
    _install_latest_stable_zig
    _install_latest_stable_nvim
    _install_esp_dev_environment
}

# Run the installation.
run;
