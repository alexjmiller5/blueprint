#!/bin/bash
while read app; do
    osascript -e "tell application \"System Events\" to make new login item at end with properties {path:\"/Applications/${app}.app\", hidden:false}"
done < "$HOME/blueprint/modules/login_items/items.txt"