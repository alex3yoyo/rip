#!/bin/bash

URLS="$@"

rip() {
    local url="$1"
    ./rip.py "$url"
    log "$url"
}

log() {
    local url="$1"
    if [[ "$i" == *"getgonewild"* ]]; then
        echo "$i" >> ./logs/getgonewild.log
        return true
    elif [[ "$i" == *"imgur"* ]]; then
        echo "$i" >> ./logs/imgur.log
        return true
    elif [[ "$i" == *"web.stagram"* ]]; then
        echo "$i" >> ./logs/instagram.log
        return true
    elif [[ "$i" == *"minus"* ]]; then
        echo "$i" >> ./logs/minus.log
        return true
    elif [[ "$i" == *"tumblr"* ]]; then
        echo "$i" >> ./logs/tumblr.log
        return true
    else
        echo "$i" >> ./logs/log.log
        return false
    fi
}

for i in "$URLS"; do
    ./rip.py "$i"
done
