FROM mcr.microsoft.com/powershell:lts-windowsservercore-ltsc2022

# USER ContainerAdministrator

WORKDIR /data

SHELL ["/Program Files/PowerShell/latest/pwsh.exe", "-Command"]

# RUN Invoke-WebRequest -Outfile vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe \
#  && .\vc_redist.x64.exe /install /quiet /norestart \
#  && Wait-Process $(Get-Process vc_redist.x64 | Select-Object -ExpandProperty Id) \
#  && Remove-Item vc_redist.x64.exe

# USER ContainerUser

RUN Invoke-WebRequest -Outfile lip-windows-amd64.zip https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip \
 && Expand-Archive lip-windows-amd64.zip lip \
 && Move-Item lip\lip.exe . \
 && Remove-Item -Recurse lip-windows-amd64.zip, lip

COPY entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["/Program Files/PowerShell/latest/pwsh.exe", "/entrypoint.ps1"]
