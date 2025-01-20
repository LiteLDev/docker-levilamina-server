FROM debian:12-slim

RUN apt update \
       && apt install -y \
       unzip \
       wget \
       && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 \
       && mkdir -pm755 /etc/apt/keyrings \
       && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
       && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
       && sed -i -e's/ main/ main contrib/g' /etc/apt/sources.list.d/debian.sources \
       && apt update \
       && apt install -y --install-recommends winehq-stable \
       && apt install -y winetricks xvfb \
       && winecfg \
       && xvfb-run winetricks -q vcrun2022 \
       && apt clean \
       && rm -rf /var/lib/apt/lists/*

ADD https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip lip-windows-amd64.zip

RUN unzip lip-windows-amd64.zip -d /opt/lip/ \
       && rm lip-windows-amd64.zip

COPY --chmod=755 lip /usr/local/bin/lip

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["entrypoint.sh"]
