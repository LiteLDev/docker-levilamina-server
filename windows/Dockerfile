FROM mcr.microsoft.com/windows/servercore:ltsc2022@sha256:c7c591fe3a010bc641906723ad583ffe2fc14b472de6e6453ea26eaa3689d16e

RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronparker/vcredist/refs/heads/gh-pages/install.ps1'))

ADD https://github.com/futrime/lip/releases/latest/download/lip-cli-win-x64-self-contained.zip lip.zip

RUN mkdir "\Program Files\lip" \
 && cd "\Program Files\lip" \
 && tar -x -f \lip.zip \
 && del \lip.zip \
 && mklink \Windows\lip.exe "\Program Files\lip\lip.exe"

COPY entrypoint.cmd /Windows/entrypoint.cmd

WORKDIR /data

ENTRYPOINT ["entrypoint.cmd"]

