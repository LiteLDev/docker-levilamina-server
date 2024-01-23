FROM mcr.microsoft.com/windows/servercore:ltsc2022

USER ContainerAdministrator

RUN md "C:\scripts"
COPY ["scripts/*", "C:/scripts"]

ENV Path="%Path%;C:/Program Files (x86)/busybox;C:\Program Files (x86)\Lip"
COPY ["src/VC_redist.x64.exe", "C:/"]
RUN VC_redist.x64.exe /install /quiet /norestart
RUN del VC_redist.x64.exe

RUN md "C:\Program Files (x86)\Busybox"
COPY ["src/busybox.exe", "C:/Program Files (x86)/busybox/"]


RUN md "C:\Program Files (x86)\Lip"
RUN ["busybox", "wget", "-O", "C:/Program Files (x86)/Lip/lip-windows-amd64.zip", "https://github.com/lippkg/lip/releases/download/v0.19.0/lip-windows-amd64.zip"]
RUN ["busybox", "unzip", "C:/Program Files (x86)/Lip/lip-windows-amd64.zip", "-d", "C:/Program Files (x86)/Lip"]
RUN del "C:\Program Files (x86)\Lip\lip-windows-amd64.zip"

ENTRYPOINT ["busybox", "bash", "-c", "C:/scripts/entrypoint.sh"]
WORKDIR C:/data