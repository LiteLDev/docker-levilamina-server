FROM mcr.microsoft.com/windows/servercore:ltsc2022@sha256:d4c6d1a8a1a306b12691c3b2e5e3a8bfad786cbd6b7831cd74a9a6a99eab08ad

ARG LIP_VERSION=0.34.5

ADD https://github.com/futrime/lip/releases/download/v${LIP_VERSION}/lip-${LIP_VERSION}-win-x64.zip lip.zip

RUN mkdir "\Program Files\lip" \
    && cd "\Program Files\lip" \
    && tar -x -f \lip.zip \
    && del \lip.zip \
    && mklink \Windows\lip.exe "\Program Files\lip\lip.exe"

COPY entrypoint.cmd /Windows/entrypoint.cmd

WORKDIR /data

ENTRYPOINT ["entrypoint.cmd"]
