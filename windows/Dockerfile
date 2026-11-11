FROM mcr.microsoft.com/windows/servercore:ltsc2022@sha256:d4c6d1a8a1a306b12691c3b2e5e3a8bfad786cbd6b7831cd74a9a6a99eab08ad

ARG LIP_VERSION=0.41.0-beta.1
ARG PYTHON_VERSION=3.12.10

SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# The Visual C++ runtime that LeviLamina and the server need, and the .NET runtime that lip needs.
RUN Invoke-WebRequest https://aka.ms/vc14/vc_redist.x64.exe -OutFile vc_redist.x64.exe; \
    Start-Process vc_redist.x64.exe -ArgumentList '/install', '/quiet', '/norestart' -Wait; \
    Remove-Item vc_redist.x64.exe; \
    Invoke-WebRequest https://dot.net/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1; \
    ./dotnet-install.ps1 -Channel 10.0 -Runtime dotnet -InstallDir 'C:\Program Files\dotnet'; \
    Remove-Item dotnet-install.ps1

# The Python engine of LegacyScriptEngine loads python312.dll and the standard library of a Python
# 3.12 found through PATH.
RUN Invoke-WebRequest "https://www.nuget.org/api/v2/package/python/$env:PYTHON_VERSION" -OutFile python.zip; \
    Expand-Archive python.zip python; \
    Move-Item python\tools 'C:\Program Files\Python'; \
    Remove-Item python, python.zip -Recurse

RUN Invoke-WebRequest "https://github.com/LiteLDev/lip/releases/download/v$env:LIP_VERSION/lip-$env:LIP_VERSION-win-x64.zip" -OutFile lip.zip; \
    Expand-Archive lip.zip 'C:\Program Files\lip'; \
    Remove-Item lip.zip; \
    [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Program Files\lip;C:\Program Files\dotnet;C:\Program Files\Python', 'Machine'); \
    & 'C:\Program Files\lip\lip.exe' --version

COPY entrypoint.cmd /Windows/entrypoint.cmd

WORKDIR /data

ENTRYPOINT ["entrypoint.cmd"]
