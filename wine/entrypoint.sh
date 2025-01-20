#! /usr/bin/env sh

VERSION="${VERSION:-LATEST}"

if [ "$EULA" != "TRUE" ]
then
    echo "You must accept the Minecraft EULA to run the server"
    echo "Set the environment variable EULA to TRUE to accept it"
    exit 1
fi

export WINEDEBUG="${WINEDEBUG:--all}"

if [ ! -f "bedrock_server_mod.exe" ]
then
    winecfg
    xvfb-run -a winetricks -q vcrun2022

    if [ "$GITHUB_MIRROR_URL" != "" ]
    then
        lip config GitHubMirrorURL $GITHUB_MIRROR_URL
    fi

    if [ "$GO_MODULE_PROXY_URL" != "" ]
    then
        lip config GoModuleProxyURL $GO_MODULE_PROXY_URL
    fi

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

cat | wine64 bedrock_server_mod.exe
