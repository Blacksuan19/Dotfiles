#!/bin/bash

# Get the current color scheme
PROFILE="Main"
PROFILE1="Main.profile"

# change color scheme of current active session
for instance in $(qdbus | grep org.kde.konsole); do
    for session in $(qdbus "$instance" | grep -E '^/Sessions/'); do
        qdbus "$instance" "$session" org.kde.konsole.Session.setProfile "$PROFILE"
    done
done

# change the default profile for next time console open
sed -i "s/^DefaultProfile=.*/DefaultProfile=$PROFILE1/" ~/.config/konsolerc
