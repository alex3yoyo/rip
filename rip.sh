#!/bin/bash

URLS="$@"

rip() {
    local url="$1"
    ./rip.py "$url"
    log "$url"
    return 0
}

log() {
    local url="$1"

    [[ ! -d logs ]] && mkdir "logs"

    if [[ "$i" == *"getgonewild"* ]]; then
        echo "$i" >> "logs/getgonewild.log"
        return 0
    elif [[ "$i" == *"imgur"* ]]; then
        echo "$i" >> "logs/imgur.log"
        return 0
    elif [[ "$i" == *"web.stagram"* ]]; then
        echo "$i" >> "logs/instagram.log"
        return 0
    elif [[ "$i" == *"minus"* ]]; then
        echo "$i" >> "logs/minus.log"
        return 0
    elif [[ "$i" == *"tumblr"* ]]; then
        echo "$i" >> "logs/tumblr.log"
        return 0
    else
        echo "$i" >> "logs/log.log"
        return 1
    fi
}

for i in "$URLS"; do
    rip "$i"
done
