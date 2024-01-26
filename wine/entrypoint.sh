#! /usr/bin/env sh

EULA="${EULA:-FALSE}"
PACKAGES="${PACKAGES:-}"
VERSION="${VERSION:-LATEST}"

if [ $(echo "$EULA" | tr '[:lower:]' '[:upper:]') != "TRUE" ]
then
    echo "You must accept the Minecraft EULA to run the server"
    echo "Set the environment variable EULA to TRUE to accept it"
    exit 1
fi

export WINEDEBUG="${WINEDEBUG:--all}"

if [ ! -f "bedrock_server_mod.exe" ]; then
    if [ "$VERSION" = "LATEST" ]
    then
        lip install -y github.com/LiteLDev/LeviLamina
    else
        lip install -y github.com/LiteLDev/LeviLamina@$VERSION
    fi

    for package in $PACKAGES
    do
        lip install -y $package
    done
fi

wine64 bedrock_server_mod.exe
