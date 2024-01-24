FROM debian:12-slim

WORKDIR /data

RUN apt update \
 && apt install -y \
        unzip \
        wget \
 && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 \
 && mkdir -pm755 /etc/apt/keyrings \
 && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
 && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
 && apt update \
 && apt install -y --install-recommends winehq-stable \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip \
 && unzip -q lip-windows-amd64.zip lip.exe \
 && rm lip-windows-amd64.zip

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
