FROM mcr.microsoft.com/windows/servercore:ltsc2022

RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://vcredist.com/install.ps1'))

ADD https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip lip-windows-amd64.zip

RUN mkdir "\Program Files\lip" \
 && cd "\Program Files\lip" \
 && tar -x -f \lip-windows-amd64.zip \
 && del \lip-windows-amd64.zip \
 && mklink \Windows\lip.exe "\Program Files\lip\lip.exe"

COPY entrypoint.cmd /Windows/entrypoint.cmd

WORKDIR /data

ENTRYPOINT ["entrypoint.cmd"]
