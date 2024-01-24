FROM mcr.microsoft.com/windows/servercore:ltsc2022

USER ContainerAdministrator

RUN md "C:\scripts"
COPY ["scripts/*", "C:/scripts/"]

ENV Path="%Path%;C:/Program Files (x86)/Busybox;C:\Program Files (x86)\Lip"

RUN md "C:\Program Files (x86)\Busybox"
RUN C:\Windows\System32\curl.exe -o "C:\Program Files (x86)\Busybox\busybox.exe" -L "https://frippery.org/files/busybox/busybox.exe"

RUN ["busybox", "bash", "-c", "C:/scripts/build.sh"]

ENTRYPOINT ["busybox", "bash", "-c", "C:/scripts/entrypoint.sh"]
WORKDIR C:/data