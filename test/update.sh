#!/bin/bash

sort_file_date() {
    local n=1
    for q in `ls -t`; do
        local ext="${q##*.}"
        local count=$(printf %03d $n)
        local newname="${count}_${i}.${ext}"
        mv "$q" "$newname"
        local n=$(($n+1))
    done
    wait
}

USERS=$(<users.txt)

for i in $USERS; do
        echo "${i}"

        if [[ ! -d "rips/${i}" ]]; then
            mkdir "rips/${i}"
        fi
        if [[ ! -f "lists/${i}.txt" ]]; then
            touch "lists/${i}.txt"
        fi

        echo "Checking for new photos from ${i}"
        URL="http://web.stagram.com/n/${i}/"
        (../rip.cgi "${URL}" "false" "true")
        wait

        mv "rips/instagram_${i}.txt" "lists/${i}.new.txt"
        mv "lists/${i}.txt" "lists/${i}.old.txt"
        comm -13 <(sort lists/${i}.old.txt) <(sort lists/${i}.new.txt) > "lists/${i}.geturls.txt"

        echo "Downloading new photos for ${i}"
        cd "rips/${i}"
        for k in $(<../../lists/${i}.geturls.txt); do
            wget --no-verbose "${k}" &
        done
        wait
        sort_file_date
        cd ../../

        touch "lists/${i}.txt"
        cat "lists/${i}.geturls.txt" "lists/${i}.old.txt" > "lists/${i}.txt"
        rm "lists/${i}.new.txt" "lists/${i}.old.txt" "lists/${i}.geturls.txt"
done

wait
rm "recent_rips.lst"

# tail -r ../recent_rips.lst | egrep -m 1 .
