#!/bin/bash

# Set the Konsole profile based on the color scheme
PROFILE="Light mode"
PROFILE1="Light mode.profile"

# change color scheme of current active session
for instance in $(qdbus | grep org.kde.konsole); do
    for session in $(qdbus "$instance" | grep -E '^/Sessions/'); do
        qdbus "$instance" "$session" org.kde.konsole.Session.setProfile "$PROFILE"
    done
done

# change the default profile for next time console open
sed -i "s/^DefaultProfile=.*/DefaultProfile=$PROFILE1/" ~/.config/konsolerc
