FROM mcr.microsoft.com/windows/servercore:ltsc2022@sha256:c7c591fe3a010bc641906723ad583ffe2fc14b472de6e6453ea26eaa3689d16e

ARG LIP_VERSION=0.34.4

ADD https://github.com/futrime/lip/releases/download/v${LIP_VERSION}/lip-${LIP_VERSION}-win-x64.zip lip.zip

RUN mkdir "\Program Files\lip" \
    && cd "\Program Files\lip" \
    && tar -x -f \lip.zip \
    && del \lip.zip \
    && mklink \Windows\lip.exe "\Program Files\lip\lip.exe"

COPY entrypoint.cmd /Windows/entrypoint.cmd

WORKDIR /data

ENTRYPOINT ["entrypoint.cmd"]
