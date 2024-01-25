# LeviLamina Server on Docker

A docker image that provides a LeviLamina server that will automatically download selected version at startup 

## Usage

To start the server in a Linux container, run the following command:

```sh
docker run -d -it -e EULA=TRUE -p 19132:19132/udp -v levilamina-server-data:/data ghcr.io/liteldev/levilamina-server:latest-wine
```

Or, if you want to use a Windows container, run the following command:

```sh
docker run -d -it -e EULA=TRUE -p 19132:19132/udp -v levilamina-server-data:C:/data ghcr.io/liteldev/levilamina-server:latest-windows
```

We also provide Docker Compose files for both Linux and Windows containers at [wine/compose.yaml](wine/compose.yaml) and [windows/compose.yaml](windows/compose.yaml) respectively. To use them, download the file to an empty directory and run `docker compose up -d`.

### Environment variables

- `EULA`(`FALSE`): must be set to `TRUE` to accept the [Minecraft End User License Agreement](https://minecraft.net/terms).
- `VERSION`(`LATEST`): can be set to a specific [LeviLamina](https://github.com/LiteLDev/LeviLamina/tags) version or `LATEST` to automatically download the latest version.
- `PACKAGES`(``): can be set to a list of packages to install on first run. Each package must be a valid [lip specifier](https://docs.lippkg.com/commands/lip_install.html). Both local and remote lip teeth are supported. For local packages, you may need to mount the packages to the container.
