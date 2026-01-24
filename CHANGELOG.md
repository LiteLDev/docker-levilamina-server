# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.4] - 2026-01-24

### Fixed

- Use command `wine` instead of `wine64` @dmblock
- Add missing dependency `cabextract` @dmblock

## [0.7.3] - 2026-01-24

### Fixed

- Fixed broken lip output buffering @dmblock
- Fixed wine entrypoint to setup wineprefix in /data instead of /root @dmblock
- Fixed XDG_RUNTINE_DIR warnning @dmblock
- Fixed missing msvcp140.dll by updating winetricks @dmblock

## [0.7.2] - 2025-09-18

### Changed

- Updated lip to 0.32.0

## [0.7.1] - 2025-08-12

### Added

- Added locales and locales-all to wine installation @Yushu2606

## [0.7.0] - 2025-04-12

### Changed

- Install all packages at a time

## [0.6.5] - 2025-04-01

### Changed

- Update lip to 0.31.0

## [0.6.4] - 2025-03-22

### Changed

- Update lip to 0.30.2

## [0.6.3] - 2025-03-18

### Changed

- Update lip version to 0.29.0

## [0.6.2] - 2025-03-15

### Changed

- Update lip version to 0.28.3

## [0.6.1] - 2025-03-14

### Changed

- Update lip version to 0.28.2

## [0.6.0] - 2025-03-07

### Changed

- Updated lip version to 0.27.1

## [0.5.3] - 2025-01-21

### Changed

- Optimizing wine dockerfile

## [0.5.2] - 2025-01-20

### Fixed

- Fix LeviLamina 1.0.0 operation by installing vcredist

## [0.5.1] - 2025-01-19

### Fixed

- Fix input in wine

## [0.5.0] - 2024-01-29

### Changed

- Put lip files to `/opt`.
- Use PowerShell to install Visual C++ Redistributable.

## [0.4.0] - 2024-01-24

### Changed

- Add windows container suport.
- Change Wine version to 9.

## [0.3.0] - 2024-01-12

### Changed

- LeviLamina tooth repo path to `github.com/LiteLDev/LeviLamina`.

## [0.2.1] - 2023-12-25

### Fixed

- No permission to run entrypoint.

## [0.2.0] - 2023-12-03

### Changed

- Automatically resolve Minecraft Bedrock Server version from LeviLamina version.

## [0.1.0] - 2023-12-01

First release.

[0.7.4]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.7.3...v0.7.4
[0.7.3]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.7.2...v0.7.3
[0.7.2]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.6.5...v0.7.0
[0.6.5]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.6.4...v0.6.5
[0.6.4]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.6.3...v0.6.4
[0.6.3]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.6.2...v0.6.3
[0.6.2]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.6.1...v0.6.2
[0.6.1]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.5.3...v0.6.0
[0.5.3]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.5.2...v0.5.3
[0.5.2]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/LiteLDev/docker-levilamina-server/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/LiteLDev/docker-levilamina-server/releases/tag/v0.1.0
