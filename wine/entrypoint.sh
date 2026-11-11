#! /usr/bin/env sh

set -e

VERSION="${VERSION:-LATEST}"

if [ "$EULA" != "TRUE" ]; then
    echo "You must accept the Minecraft EULA to run the server"
    echo "Set the environment variable EULA to TRUE to accept it"
    exit 1
fi

mkdir -p "$XDG_RUNTIME_DIR"

# The Visual C++ runtime that LeviLamina and the server need. winetricks lists the verbs it
# installed in winetricks.log, which also covers prefixes created by earlier images.
if ! grep -qx vcrun2026 "$WINEPREFIX/winetricks.log" 2>/dev/null; then
    WINEDEBUG=-all wineboot --init
    WINEDEBUG=-all xvfb-run -a winetricks -q vcrun2026
    wineserver --wait
fi

if [ ! -f "bedrock_server_mod.exe" ]; then
    if [ -n "$GITHUB_MIRROR_URL" ]; then
        lip config set github_proxy "$GITHUB_MIRROR_URL"
    fi

    if [ "$VERSION" = "LATEST" ]; then
        LEVILAMINA="github.com/LiteLDev/LeviLamina"
    else
        LEVILAMINA="github.com/LiteLDev/LeviLamina@$VERSION"
    fi

    # PACKAGES is a whitespace-separated list of packages.
    # shellcheck disable=SC2086
    lip install "$LEVILAMINA" $PACKAGES
fi

exec lip run
