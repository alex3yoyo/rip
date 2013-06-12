#!/bin/bash

URLS="$@"

for i in $URLS; do
        ./rip.cgi "${i}" "false" "true"

        if [[ "${i}" == *"imgur"* ]]; then
            echo "${i}" >> "logs/urls/imgur.log"
        elif [[ "${i}" == *"web.stagram"* ]]; then
            echo "${i}" >> "logs/urls/instagram.log"
        elif [[ "${i}" == *"gonewild"* ]]; then
            echo "${i}" >> "logs/urls/gonewild.log"
        elif [[ "${i}" == *"minus"* ]]; then
            echo "${i}" >> "logs/urls/minus.log"
        else
            echo "${i}" >> "logs/other_site.log"
        fi
done
