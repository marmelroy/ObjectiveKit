#!/bin/bash

# **** Update me when new Xcode versions are released! ****
PLATFORM="platform=iOS Simulator,OS=10.0,name=iPhone 7"
SDK="iphonesimulator10.0"


# It is pitch black.
set -e
function trap_handler() {
    echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
    echo "**** You have died ****"
    exit 255
}
trap trap_handler INT TERM EXIT


MODE="$1"

if [ "$MODE" = "framework" ]; then
    echo "Building and testing ObjectiveKit.framework."
    xcodebuild \
        -project ObjectiveKit.xcodeproj \
        -scheme ObjectiveKit \
        -sdk "$SDK" \
        -destination "$PLATFORM" \
        build test
    trap - EXIT
    exit 0
fi

echo "Unrecognised mode '$MODE'."
