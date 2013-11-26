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
        # URL="http://web.stagram.com/n/${i}/"
        python ../../rip.cgi "http://web.stagram.com/n/${i}/" "false" "true"
        # python ../../rip.cgi "http://statigr.am/${i}/" "false" "true"

        mv "rips/instagram_${i}.txt" "lists/${i}.new.txt"
        mv "lists/${i}.txt" "lists/${i}.old.txt"
        # Sort user.old.txt and user.new.txt, compare for differences, write new URLs to user.geturls.txt
        comm -13 <(sort lists/${i}.old.txt) <(sort lists/${i}.new.txt) > "lists/${i}.geturls.txt"

        # Download new images
        echo "Calculate number of photos to download for ${i}"
        cd "rips/${i}"
        # Calculate number of images to download
        TOTAL=0
        for k in $(<../../lists/${i}.geturls.txt); do
            TOTAL=$(($TOTAL+1))
        done
        # Download
        if [[ "${TOTAL}" -gt 0 ]]; then
            echo "Getting ${TOTAL} for user ${i}"
            echo ""
            COUNTING=0
            for k in $(<../../lists/${i}.geturls.txt); do
                COUNTING=$(($COUNTING+1))
                echo -en "\r\033[K${COUNTING}/${TOTAL}"
                wget --no-clobber --quiet --tries=10 --waitretry=1 "${k}"
            done
            echo ""
            echo "Renaming files"
            sort_file_date
        else
            echo "No new photos to download"
        fi

        # COUNTING=0
        # for k in $(<../../lists/${i}.geturls.txt); do
        #     COUNTING=$(($COUNTING+1))
        #     echo "Getting ${COUNTING}/${TOTAL}"
        #     wget --no-clobber --no-verbose --tries=10 --waitretry=1 "${k}"
        #     echo "Got ${COUNTING}/${TOTAL}"
        # done
        # wait
        # echo "Renaming files"
        # sort_file_date

        cd ../../

        touch "lists/${i}.txt"
        cat "lists/${i}.geturls.txt" "lists/${i}.old.txt" > "lists/${i}.txt"
        rm "lists/${i}.new.txt" "lists/${i}.old.txt" "lists/${i}.geturls.txt"

        unset COUNTING TOTAL
done

rm "recent_rips.lst"

exit
