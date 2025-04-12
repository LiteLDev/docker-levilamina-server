FROM debian:stable-slim@sha256:00a24d7c50ebe46934e31f6154c0434e2ab51259a65e028be42413c636385f7f

RUN apt update \
 && apt install -y unzip \
                   wget \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 \
 && mkdir -pm755 /etc/apt/keyrings \
 && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
 && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
 && sed -i -e's/ main/ main contrib/g' /etc/apt/sources.list.d/debian.sources

RUN apt update \
 && apt install -y --install-recommends winehq-stable \
                                        winetricks \
                                        xvfb \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

ADD https://github.com/futrime/lip/releases/latest/download/lip-cli-win-x64-self-contained.zip lip.zip

RUN unzip lip.zip -d /opt/lip/ \
 && rm lip.zip

COPY --chmod=755 lip /usr/local/bin/lip

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["entrypoint.sh"]
