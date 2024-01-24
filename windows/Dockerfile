FROM mcr.microsoft.com/windows/servercore:ltsc2022

USER ContainerUser

WORKDIR /Users/ContainerUser

# RUN Invoke-WebRequest -Outfile vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe \
#  && .\vc_redist.x64.exe /install /quiet /norestart \
#  && Wait-Process $(Get-Process vc_redist.x64 | Select-Object -ExpandProperty Id) \
#  && Remove-Item vc_redist.x64.exe

ADD https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip lip-windows-amd64.zip

RUN tar -x -f lip-windows-amd64.zip -v lip.exe \
 && del lip-windows-amd64.zip

COPY entrypoint.ps1 /Users/ContainerUser/entrypoint.ps1

ENTRYPOINT ["powershell", "-Command", "/Users/ContainerUser/entrypoint.ps1"]
