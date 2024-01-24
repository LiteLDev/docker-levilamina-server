FROM mcr.microsoft.com/windows/servercore:ltsc2022

WORKDIR /Users/ContainerUser/data

ADD https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip /Users/ContainerUser/data/lip-windows-amd64.zip

RUN tar -x -f lip-windows-amd64.zip -v lip.exe \
 && del lip-windows-amd64.zip

ADD https://aka.ms/vs/17/release/vc_redist.x64.exe /Users/ContainerUser/data/vc_redist.x64.exe

COPY entrypoint.ps1 /Users/ContainerUser/AppData/Local/entrypoint.ps1

ENTRYPOINT ["powershell", "-Command", "/Users/ContainerUser/AppData/Local/entrypoint.ps1"]
