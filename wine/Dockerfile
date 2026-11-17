FROM debian:stable-slim@sha256:99fc6d2a0882fcbcdc452948d2d54eab91faafc7db037df82425edcdcf950e1f

# lip runs natively on Linux. For the Windows server it installs its own Wine and the Visual C++
# runtime by itself, so the image needs neither Wine nor winetricks: only the libraries Wine and
# lip load. lip keeps its Wine in its data directory and the Wine prefix in .lip/wine of the
# server, both in the volume /data, so a second start downloads nothing.
ENV HOME=/data

ARG LIP_VERSION=0.41.0
ARG LIP_SHA256=92ce9e4c79c45bb1c6f9b2d59abbc02b9ad1612af8566777c09e0ab43cb08c99

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    libfontconfig1 \
    libfreetype6 \
    libgnutls30t64 \
    libicu76 \
    locales-all \
    tzdata \
    xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD --checksum=sha256:${LIP_SHA256} https://github.com/LiteLDev/lip/releases/download/v${LIP_VERSION}/lip-${LIP_VERSION}-linux-x64.tar.xz /tmp/lip.tar.xz

RUN mkdir -p /opt/lip \
    && tar -xJf /tmp/lip.tar.xz -C /opt/lip \
    && rm /tmp/lip.tar.xz \
    && ln -s /opt/lip/lip /usr/local/bin/lip \
    && lip --version

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /data

# lip run stops the server with the command `stop` on SIGTERM, so `docker stop` saves the world.
STOPSIGNAL SIGTERM

ENTRYPOINT ["entrypoint.sh"]
