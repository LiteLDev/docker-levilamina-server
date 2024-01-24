@echo off
setlocal

if "%EULA%"=="" set "EULA=FALSE"
if "%PACKAGES%"=="" set "PACKAGES="
if "%VERSION%"=="" set "VERSION=LATEST"

set "EULA_UPPER=%EULA:~0,1%"
if /i not "%EULA_UPPER%"=="T" (
    echo You must accept the Minecraft EULA to run the server
    echo Set the environment variable EULA to TRUE to accept it
    exit /b 1
)

if not exist "bedrock_server_mod.exe" (
    if "%VERSION%"=="LATEST" (
        lip.exe install -y github.com/LiteLDev/LeviLamina
    ) else (
        lip.exe install -y "github.com/LiteLDev/LeviLamina@%VERSION%"
    )

    if not "%PACKAGES%"=="" (
        for %%P in (%PACKAGES%) do (
            lip.exe install -y %%P
        )
    )
)

bedrock_server_mod.exe
