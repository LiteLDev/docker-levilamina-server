FROM mcr.microsoft.com/windows/servercore:ltsc2022

WORKDIR /data

SHELL ["powershell", "-Command"]

# RUN Invoke-WebRequest -Outfile vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe \
#  && .\vc_redist.x64.exe /install /quiet /norestart \
#  && Wait-Process $(Get-Process vc_redist.x64 | Select-Object -ExpandProperty Id) \
#  && Remove-Item vc_redist.x64.exe

ADD https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip /data/lip-windows-amd64.zip

RUN Expand-Archive lip-windows-amd64.zip lip; \
    Move-Item lip\lip.exe .; \
    Remove-Item -Recurse lip-windows-amd64.zip, lip;

COPY entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["powershell", "-Command", "/entrypoint.ps1"]
