#!/bin/bash

for i in "$@"; do
    echo "$i"
    ./rip.py "$i"
    # echo "$i" >> ./lists/getgonewild.txt
done
