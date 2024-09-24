#!/bin/sh
if [ -z "$1" ]; then
    echo "Path to Xcode project required"
    exit 1
fi
XCODEPROJ="$1"
grep CURRENT_PROJECT_VERSION $XCODEPROJ | uniq | sed -E "s/^.*CURRENT_PROJECT_VERSION = ([0-9]+);/\1/" | tr -d '\n'
