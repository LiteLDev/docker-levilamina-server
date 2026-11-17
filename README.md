# docker-levilamina-server

A Bedrock Dedicated Server with [LeviLamina](https://github.com/LiteLDev/LeviLamina), set up and run by
[lip](https://github.com/LiteLDev/lip) in a container.

| Image | Runs on |
| --- | --- |
| `ghcr.io/liteldev/levilamina-server:latest-wine` | Linux containers (x64). lip runs natively and runs the Windows server under the Wine it installs itself. |
| `ghcr.io/liteldev/levilamina-server:latest-windows` | Windows containers. |

```shell
docker run -d -it --name levilamina -e EULA=TRUE -p 19132:19132/udp -p 19132:19132/tcp -v levilamina-server-data:/data ghcr.io/liteldev/levilamina-server:latest-wine
```

On the first start, lip installs everything into the volume (Wine and the Visual C++ runtime, the game, LeviLamina
and the packages of `PACKAGES`); later starts download nothing. `docker stop` saves the world: lip types `stop` into
the server.

For the full guide, see [A server in Docker](https://levimc.org/tutorials/server/docker/)
([简体中文](https://levimc.org/zh-Hans/tutorials/server/docker/)).

| Variable | Default | Meaning |
| --- | --- | --- |
| `EULA` | | Must be `TRUE`: you accept the [Minecraft EULA](https://www.minecraft.net/eula). |
| `VERSION` | `LATEST` | The LeviLamina version to install, such as `26.60.7`. The game version follows from it. |
| `PACKAGES` | | Packages to install on the first start, separated by spaces. |
| `GITHUB_MIRROR_URL` | | A GitHub mirror for the downloads (lip's `github_proxy`). |
