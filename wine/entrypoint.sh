#! /usr/bin/env sh

stty size cols 80

export HOME=/data
export WINEPREFIX=/data/.wine
export XDG_RUNTIME_DIR=/data/.tmp

VERSION="${VERSION:-LATEST}"

if [ "$EULA" != "TRUE" ]
then
    echo "You must accept the Minecraft EULA to run the server"
    echo "Set the environment variable EULA to TRUE to accept it"
    exit 1
fi

if [ ! -d "/data/.tmp" ]
then
    mkdir -p /data/.tmp
fi

if [ ! -d "/data/.wine" ]
then
    winecfg
    xvfb-run -a winetricks -q vcrun2022
fi

export WINEDEBUG="${WINEDEBUG:--all}"

if [ ! -f "bedrock_server_mod.exe" ]; then
    if [ -n "$GITHUB_MIRROR_URL" ]; then
        lip config set github_proxies="$GITHUB_MIRROR_URL"
    fi

    if [ -n "$GO_MODULE_PROXY_URL" ]; then
        lip config set go_module_proxies="$GO_MODULE_PROXY_URL"
    fi

    if [ "$VERSION" = "LATEST" ]; then
        lip install github.com/LiteLDev/LeviLamina
    else
        lip install github.com/LiteLDev/LeviLamina@"$VERSION"
    fi

    if [ -n "$PACKAGES" ]; then
        lip install $PACKAGES
    fi
fi

(cat | wine bedrock_server_mod.exe) 2>/dev/null
