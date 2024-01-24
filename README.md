# LeviLamina Server on Docker

A docker image that provides a LeviLamina server that will automatically download selected version at startup 

## Usage

The following starts a LeviLamina server running a default version and exposing the default UDP port:

Linux Container:
```sh
docker run -d -it -e EULA=TRUE -p 19132:19132/udp -v levilamina-server-data:/data ghcr.io/liteldev/levilamina-server-wine
```

Windows Container:
```sh
docker run -d -it -e EULA=TRUE -p 19132:19132/udp -v C:/levilamina-server-data:C:/data ghcr.io/liteldev/levilamina-server-windows
```

If you plan to use the server in production, it is recommended to use Docker Compose to manage the container. You can use the following `compose.yaml` file as a template:

Linux Container:
```yml
services:
  mc-server:
    image: ghcr.io/liteldev/levilamina-server-wine
    environment:
      EULA: TRUE
      VERSION: 0.4.2
      PACKAGES: |
        github.com/LiteLDev/LeviAntiCheat@0.1.1
    ports:
      - 19132:19132/udp
    volumes:
      - levilamina-server-data:/data
    stdin_open: true
    tty: true

volumes:
  levilamina-server-data:
```

Linux Container:
```yml
services:
  mc-server:
    image: ghcr.io/liteldev/levilamina-server-wine
    environment:
      EULA: TRUE
      VERSION: 0.4.2
      PACKAGES: |
        github.com/LiteLDev/LeviAntiCheat@0.1.1
    ports:
      - 19132:19132/udp
    volumes:
      - C:levilamina-server-data:C:/data
    stdin_open: true
    tty: true

volumes:
  levilamina-server-data:
```

### Environment variables

- `EULA`(`FALSE`): must be set to `TRUE` to accept the [Minecraft End User License Agreement](https://minecraft.net/terms).
- `VERSION`(`LATEST`): can be set to a specific [LeviLamina](https://github.com/LiteLDev/LeviLamina/tags) version or `LATEST` to automatically download the latest version.
- `PACKAGES`(``): can be set to a list of packages to install on first run. Each package must be a valid [lip specifier](https://docs.lippkg.com/commands/lip_install.html). Both local and remote lip teeth are supported. For local packages, you may need to mount the packages to the container.
