#!/bin/bash

function EXIT (){
    unset -f makeDir renamePics
    unset NAME
    echo "Done: $?"
    exit "$?"
}

trap "EXIT" TERM INT 0

NAME="$1"
function makeDir (){
    local YN
    echo "Name does not exist. Make a folder for it? (y/n)"
    read "YN"
    if [[ "$YN" == "y" ]]; then
        mkdir "$NAME"
        echo "Created directory $NAME"
    else
        exit -1
    fi
}

[[ ! -d "$NAME" ]] && makeDir

cd "$NAME"

function renamePics (){
    local n=$(find . -maxdepth 1 -type f -name "$NAME*" ! -name ".*" | wc -l)
    local j=1

    echo "Renaming $(find . -maxdepth 1 -type f ! -name "$NAME*" ! -name ".*" | wc -l) files."

    local IFS=$(echo -en "\n\b")
    for i in `find . -maxdepth 1 -type f ! -name "$NAME*" ! -name ".*"`; do
            k=$((n+j))
            local filename=$(basename "$i")
            local EXT="${filename##*.}"
            if [[ $k -lt 10 ]]; then
                local NEW="${NAME}_00${k}.${EXT}"
                mv "$i" "$NEW"
            elif [[ $k -ge 10 && $k -lt 100 ]]; then
                local NEW="${NAME}_0${k}.${EXT}"
                mv "$i" "$NEW"
            elif [[ $k -ge 100 && $k -lt 1000 ]]; then
                local NEW="${NAME}_${k}.${EXT}"
                mv "$i" "$NEW"
            else
                echo "Too many items"
                exit 1
            fi
            local j=$((j+1))
    done
}

renamePics
