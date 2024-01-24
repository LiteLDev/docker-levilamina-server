FROM ghcr.io/futrime/windows-servercore-vcredist:10.0.20348.2227-amd64

WORKDIR /Users/ContainerUser/data

ADD https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip /Users/ContainerUser/data/lip-windows-amd64.zip

RUN tar -x -f lip-windows-amd64.zip -v lip.exe \
 && del lip-windows-amd64.zip

COPY entrypoint.cmd /Users/ContainerUser/AppData/Local/entrypoint.cmd

ENTRYPOINT ["/Users/ContainerUser/AppData/Local/entrypoint.cmd"]
