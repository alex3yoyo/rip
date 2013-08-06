#!/bin/bash

sort_file_date() {
    # To avoid renamed files overwriting non-renamed files, files must be named twice
    # First round of renaming: TEMPNAME-123_user.jpg
    local n=1
    for q in `ls -t`; do
        local ext="${q##*.}"
        local count=$(printf %03d $n)
        local newname="TEMPNAME-${count}_${i}.${ext}"
        mv "$q" "$newname"
        local n=$(($n+1))
    done
    # Second (and final) round of renaming: 123_user.jpg
    local n=1
    for q in `ls -t`; do
        local ext="${q##*.}"
        local count=$(printf %03d $n)
        local newname="${count}_${i}.${ext}"
        mv "$q" "$newname"
        local n=$(($n+1))
    done
}

# Get the list of users, store to USERS
USERS=$(<users.txt)

for i in $USERS; do
        echo "${i}"

        if [[ ! -d "rips/${i}" ]]; then
            mkdir "rips/${i}"
        fi
        if [[ ! -f "lists/${i}.txt" ]]; then
            touch "lists/${i}.txt"
        fi

        # Get URLs of all images for the user
        echo "Checking for new photos from ${i}"
        URL="http://web.stagram.com/n/${i}/"
        (../../rip.cgi "${URL}" "false" "true")
        wait

        mv "rips/instagram_${i}.txt" "lists/${i}.new.txt"
        mv "lists/${i}.txt" "lists/${i}.old.txt"
        # Sort user.old.txt and user.new.txt, compare for differences, write new URLs to user.geturls.txt
        comm -13 <(sort lists/${i}.old.txt) <(sort lists/${i}.new.txt) > "lists/${i}.geturls.txt"

        # Download new images
        echo "Downloading new photos for ${i}"
        cd "rips/${i}"
        # Calculate number of images to download
        total=1
        for k in $(<../../lists/${i}.geturls.txt); do
            total=$(($total+1))
        done
        # Download
        counting=1
        for k in $(<../../lists/${i}.geturls.txt); do
            echo "Getting ${counting}/${total}"
            wget --no-clobber --no-verbose --tries=25 --waitretry=1 "${k}"
            echo "Got ${counting}"
            counting=$(($counting+1))
        done
        wait
        echo "Renaming files"
        sort_file_date
        cd ../../

        touch "lists/${i}.txt"
        cat "lists/${i}.geturls.txt" "lists/${i}.old.txt" > "lists/${i}.txt"
        rm "lists/${i}.new.txt" "lists/${i}.old.txt" "lists/${i}.geturls.txt"
done

rm "recent_rips.lst"

exit
