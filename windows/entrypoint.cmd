@echo off
setlocal

if "%VERSION%"=="" set "VERSION=LATEST"

if not "%EULA%"=="TRUE" (
    echo You must accept the Minecraft EULA to run the server
    echo Set the environment variable EULA to TRUE to accept it
    exit /b 1
)

if not exist "C:\Windows\System32\vcruntime140_1.dll" (
    powershell -Command "Invoke-WebRequest -Uri https://aka.ms/vc14/vc_redist.x64.exe -OutFile vc_redist.x64.exe
    vc_redist.x64.exe /install /quiet /norestart
    del vc_redist.x64.exe
)

if not exist "C:\Program Files\dotnet\" (
    powershell -Command "Invoke-WebRequest -Uri https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-win-x64.exe -OutFile dotnet-runtime.exe
    dotnet-runtime.exe /install /quiet /norestart
    del dotnet-runtime.exe
)

if not exist "bedrock_server_mod.exe" (
    if not "%GITHUB_MIRROR_URL%"=="" (
        lip.exe config set github_proxy %GITHUB_MIRROR_URL%
    )

    if not "%GO_MODULE_PROXY_URL%"=="" (
        lip.exe config set go_module_proxy %GO_MODULE_PROXY_URL%
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
