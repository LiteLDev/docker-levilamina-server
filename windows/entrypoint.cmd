@echo off
setlocal

if "%VERSION%"=="" set "VERSION=LATEST"

if not "%EULA%"=="TRUE" (
    echo You must accept the Minecraft EULA to run the server
    echo Set the environment variable EULA to TRUE to accept it
    exit /b 1
)

rem lip installs the Visual C++ runtime itself, but on Windows it asks for elevation to do so,
rem which a container cannot grant: install it here, and lip finds it installed.
if not exist "C:\Windows\System32\vcruntime140_1.dll" (
    powershell -Command "Invoke-WebRequest -Uri https://aka.ms/vc14/vc_redist.x64.exe -OutFile vc_redist.x64.exe"
    vc_redist.x64.exe /install /quiet /norestart
    del vc_redist.x64.exe
)

if not "%GITHUB_MIRROR_URL%"=="" (
    lip.exe config set github_proxy %GITHUB_MIRROR_URL%
)

rem The first start sets the server up: lip installs the game that fits LeviLamina, LeviLamina,
rem and the packages of PACKAGES in one go.
if not exist "bedrock_server_mod.exe" (
    if "%VERSION%"=="LATEST" (
        lip.exe install --accept-eula github.com/LiteLDev/LeviLamina %PACKAGES%
    ) else (
        lip.exe install --accept-eula "github.com/LiteLDev/LeviLamina@%VERSION%" %PACKAGES%
    )
    if errorlevel 1 exit /b 1
)

rem lip runs the server, passes the console through, and types `stop` when the container stops.
lip.exe run
