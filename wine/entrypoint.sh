#!/usr/bin/env sh
set -e

VERSION="${VERSION:-LATEST}"

if [ "$EULA" != "TRUE" ]; then
    echo "You must accept the Minecraft EULA to run the server"
    echo "Set the environment variable EULA to TRUE to accept it"
    exit 1
fi

if [ -n "$GITHUB_MIRROR_URL" ]; then
    lip config set github_proxy "$GITHUB_MIRROR_URL"
fi

# A server that an image with lip v0.x set up has a tooth_lock.json and no state file of lip
# v0.41, so lip finds no game in it. A setup with its game and LeviLamina version makes the state
# file, and keeps the worlds, the settings and the other mods.
if [ -f tooth_lock.json ] && [ ! -f .lip/state.json ]; then
    INSTALLED="$(lip list)"
    GAME="$(echo "$INSTALLED" | sed -n 's|.*github\.com/LiteLDev/bds@\([^ ]*\).*|\1|p' | head -n 1)"
    LOADER_VERSION="$(echo "$INSTALLED" | sed -n 's|.*github\.com/LiteLDev/LeviLamina@\([^ ]*\).*|\1|p' | head -n 1)"
    lip setup --accept-eula --game "$GAME" --loader "levilamina@$LOADER_VERSION"
fi

# The first start sets the server up: lip installs the game that fits LeviLamina, LeviLamina, and
# the packages of PACKAGES in one go, and before that its Wine and the Visual C++ runtime.
if [ ! -f bedrock_server_mod.exe ]; then
    if [ "$VERSION" = "LATEST" ]; then
        LOADER="github.com/LiteLDev/LeviLamina"
    else
        LOADER="github.com/LiteLDev/LeviLamina@$VERSION"
    fi

    # shellcheck disable=SC2086 # PACKAGES is a list separated by spaces
    lip install --accept-eula "$LOADER" $PACKAGES
fi

# lip runs bedrock_server_mod.exe under its Wine, passes the console through, and on SIGTERM
# (docker stop) types `stop` so that the server saves the world and exits.
exec lip run
