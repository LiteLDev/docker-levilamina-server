#! /usr/bin/env sh

# Set default values for environment variables
VERSION="${VERSION:-LATEST}"
PACKAGES="${PACKAGES:-}"
EULA="${EULA:-FALSE}"

# Enforce EULA
if [ $(echo "$EULA" | tr '[:lower:]' '[:upper:]') != "TRUE" ]
then
    echo "You must accept the Minecraft EULA to run the server."
    echo "Set the environment variable EULA to true to accept it."
    exit 1
fi

# Enable core dumps
export WINEDEBUG="${WINEDEBUG:--all}"

# Install dependencies on first run
# Test if bedrock_server_mod.exe exists
if [ ! -f "bedrock_server_mod.exe" ]; then
    # Install LeveLamina
    if [ "$VERSION" = "LATEST" ]
    then
        lip install -y github.com/LiteLDev/LeviLamina
    else
        lip install -y github.com/LiteLDev/LeviLamina@$VERSION
    fi

    # Install packages, line by line
    for package in $PACKAGES
    do
        lip install -y $package
    done

    ./PeEditor.exe --pause=false --mod=true
fi

./bedrock_server_mod.exe
