FROM mcr.microsoft.com/windows/servercore:ltsc2025@sha256:c84c293ed888ab62677e7c4354bb836f608be63353d31215f0276147888b24b9

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
