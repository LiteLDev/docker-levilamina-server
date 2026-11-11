FROM debian:stable-slim@sha256:99fc6d2a0882fcbcdc452948d2d54eab91faafc7db037df82425edcdcf950e1f

ARG LIP_VERSION=0.41.0-beta.1
ARG PYTHON_VERSION=3.12.10

ENV HOME=/data
ENV WINEPREFIX=/data/.wine
ENV XDG_RUNTIME_DIR=/data/.tmp
ENV DOTNET_ROOT=/usr/share/dotnet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
# Wine adds WINEPATH to the PATH of Windows programs: the Python engine of LegacyScriptEngine finds
# Python there.
ENV WINEPATH=Z:\\opt\\python

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    libicu-dev \
    locales \
    locales-all \
    unzip \
    wget \
    xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# The WineHQ repository of the Debian release of the base image.
RUN . /etc/os-release \
    && dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -qO /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -qNP /etc/apt/sources.list.d/ "https://dl.winehq.org/wine-builds/debian/dists/${VERSION_CODENAME}/winehq-${VERSION_CODENAME}.sources" \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-stable xvfb xauth cabextract \
    && wget -qO /usr/bin/winetricks https://github.com/Winetricks/winetricks/raw/b792287f5bec9086916aa9b81788e0ea38f02c24/src/winetricks \
    && chmod +x /usr/bin/winetricks \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# lip runs natively; it runs the hooks of packages and the server through Wine.
RUN wget -qO /tmp/dotnet-install.sh https://dot.net/v1/dotnet-install.sh \
    && bash /tmp/dotnet-install.sh --channel 10.0 --runtime dotnet --install-dir "$DOTNET_ROOT" \
    && rm /tmp/dotnet-install.sh \
    && mkdir -p /opt/lip \
    && wget -qO- "https://github.com/LiteLDev/lip/releases/download/v${LIP_VERSION}/lip-${LIP_VERSION}-linux-x64.tar.xz" \
    | tar -xJ -C /opt/lip \
    && ln -s /opt/lip/lip /usr/local/bin/lip \
    && lip --version

# The Python engine of LegacyScriptEngine loads python312.dll and the standard library of a Windows
# Python 3.12 found through PATH.
RUN wget -qO /tmp/python.zip "https://www.nuget.org/api/v2/package/python/${PYTHON_VERSION}" \
    && unzip -q /tmp/python.zip 'tools/*' -d /tmp/python \
    && mv /tmp/python/tools /opt/python \
    && rm -rf /tmp/python /tmp/python.zip

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /data

# lip run sends "stop" to the server when it receives SIGTERM, and exits when the server does.
STOPSIGNAL SIGTERM

ENTRYPOINT ["entrypoint.sh"]
