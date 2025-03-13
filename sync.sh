#!/bin/bash

echo "Syncing files with GitHub..."

echo -e "\npull"
git pull

echo -e "\nadd"
if git add .; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

echo -e "\ncommit"
git commit -m "Updated via sync.sh"

echo -e "\npush"
git push

echo -e "\n\nFiles synced with GitHub."