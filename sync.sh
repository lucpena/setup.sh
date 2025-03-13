#!/bin/bash

git pull
git add .
git commit -m "Updated via sync.sh"
git push

echo "Files synced with GitHub."