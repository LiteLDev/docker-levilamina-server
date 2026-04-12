FROM debian:stable-slim@sha256:99fc6d2a0882fcbcdc452948d2d54eab91faafc7db037df82425edcdcf950e1f

ENV HOME=/data
ENV WINEPREFIX=/data/.wine
ENV XDG_RUNTIME_DIR=/data/.tmp

ARG LIP_VERSION=0.34.5

RUN apt update \
    && apt install -y unzip \
    wget \
    locales \
    locales-all \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && sed -i -e's/ main/ main contrib/g' /etc/apt/sources.list.d/debian.sources

RUN apt update \
    && apt install -y --install-recommends winehq-stable xvfb cabextract \
    && wget -O /usr/bin/winetricks https://github.com/Winetricks/winetricks/raw/b792287f5bec9086916aa9b81788e0ea38f02c24/src/winetricks \
    && chmod +x /usr/bin/winetricks \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/futrime/lip/releases/download/v${LIP_VERSION}/lip-${LIP_VERSION}-win-x64.zip lip.zip

RUN unzip lip.zip -d /opt/lip/ \
    && rm lip.zip

COPY --chmod=755 lip /usr/local/bin/lip

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["entrypoint.sh"]
