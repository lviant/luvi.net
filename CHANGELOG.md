# Changelog

This changelog records notable releases of luvi.net for readers who track werc and Ansible infrastructure changes alongside front-end site features. Format follows [Keep a Changelog](https://keepachangelog.com/).

## Versioning

Versions use only `<major>.<minor>`. A minor release marks a new werc or Ansible revision, such as a deploy pipeline change, role restructure, or templating update. A minor release also covers a new front-end feature or subsite. A major release is reserved for a site-wide redesign or a new subsite launch. The site remains pre-1.0.

Content-only changes, such as adding a single meme image, do not receive their own version. They appear as a note under the nearest surrounding release instead.

## [v0.6] - 2026-08-15

### Changed

- Footer and top-bar layout now render through shared `.tpl` partials, replacing inline markup.
- Each site's werc config now templates from shared Ansible data.
- Favicon management now fixes rc templating syntax and werc inheritance issues.
- The "last updated" timestamp now appears on the main page.
- Meta headers are tidier, and webmanifest deployment is in place.

## [v0.5] - 2026-08-14

### Added

- IndieWeb `h-card` and `rel-me` microformat markup across the header and footer, including nested cards for the site and its subsites.

## [v0.4] - 2026-08-13

### Added

- luvi-live project entry and about page updates.
- Favicon and banner templates, including a new site favicon.

### Changed

- The top bar now uses a template.
- Emoji references now use Unicode escapes.

## [v0.3] - 2026-08-08

### Added

- CC BY-NC-SA 4.0 license, with a footer template and a license exception for the memes subsite.
- `justfile` with Ansible deploy wrappers.

## [v0.2] - 2026-08-07

### Added

- AI-productivity documentation page.

### Changed

- Ansible now uses per-site roles: `site_luvi_net`, `site_gameboy_luvi_net`, and `site_memes_luvi_net`.
- The GitLab topbar link, the people link, and the lookup filter in the gameboy and memes templates are fixed.

### Notes

- Four standalone meme images landed between this release and the previous one, without a version bump:
  - nonsense gif (2025-07-29)
  - allthetime (2025-09-09)
  - drop and neat (2025-12-12)
  - democracy meme (2026-01-22)

## [v0.1] - 2025-07-16

### Added

- Initial werc site configuration for luvi.net, gameboy.luvi.net, and memes.luvi.net.
- Ansible deploy pipeline and GitLab CI, including SAST and secret detection.
- Project README and license.
