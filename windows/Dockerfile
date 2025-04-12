FROM mcr.microsoft.com/windows/servercore:ltsc2025@sha256:39fa6d04598fff134c079d3547efd9726dd967e540a76f24e5181dbdea4780d0

RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://vcredist.com/install.ps1'))

ADD https://github.com/futrime/lip/releases/latest/download/lip-cli-win-x64-self-contained.zip lip.zip

RUN mkdir "\Program Files\lip" \
 && cd "\Program Files\lip" \
 && tar -x -f \lip.zip \
 && del \lip.zip \
 && mklink \Windows\lip.exe "\Program Files\lip\lip.exe"

COPY entrypoint.cmd /Windows/entrypoint.cmd

WORKDIR /data

ENTRYPOINT ["entrypoint.cmd"]
