@echo off
setlocal

if "%VERSION%"=="" set "VERSION=LATEST"

if not "%EULA%"=="TRUE" (
    echo You must accept the Minecraft EULA to run the server
    echo Set the environment variable EULA to TRUE to accept it
    exit /b 1
)

if not exist "bedrock_server_mod.exe" (
    if not "%GITHUB_MIRROR_URL%"=="" (
        lip.exe config set github_proxies=%GITHUB_MIRROR_URL%
    )

    if not "%GO_MODULE_PROXY_URL%"=="" (
        lip.exe config set go_module_proxies=%GO_MODULE_PROXY_URL%
    )

    if "%VERSION%"=="LATEST" (
        lip.exe install github.com/LiteLDev/LeviLamina
    ) else (
        lip.exe install "github.com/LiteLDev/LeviLamina@%VERSION%"
    )

    if not "%PACKAGES%"=="" (
        lip.exe install %PACKAGES%
    )
)

bedrock_server_mod.exe
