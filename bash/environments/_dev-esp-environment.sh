source ~/.bashrc
source /work/SDKs/esp-idf-$ESP_IDF_VER/export.sh

function set-target {
    idf.py set-target "$@"
}

function menuconfig {
    idf.py menuconfig "$@"
}

function build {
    idf.py build "$@"
}

function flash {
    if [[ "" == "$1" ]]; then
        echo "Expected a value for the ESP32 device port as the first argument"
        return
    fi
    idf.py -p $1 flash
}

function flash-erase {
    if [[ "" == "$1" ]]; then
        echo "Expected a value for the ESP32 device port as the first argument"
        return
    fi

    idf.py -p $1 erase-flash
}

function otadata-erase {
    if [[ "" == "$1" ]]; then
        echo "Expected a value for the ESP32 device port as the first argument"
        return
    fi

    idf.py -p $1 erase-otadata
}

function monitor {
    if [[ "" == "$1" ]]; then
        echo "Expected a value for the ESP32 device port as the first argument"
        return
    fi

    idf.py -p $1 monitor
}

