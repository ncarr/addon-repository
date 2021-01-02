# Changelog

## 1.0.0-alpha.12

- Attempted to remove D-Bus

## 1.0.0-alpha.11

- Turned off D-Bus support in Avahi
- Created a folder for D-Bus to store its socket

## 1.0.0-alpha.10

- Added a D-Bus daemon into the container directly

## 1.0.0-alpha.9

- Mapped the host D-Bus service into the container
- Added an events section to nginx.conf

## 1.0.0-alpha.8

- Fixed shebang to point to /bin/sh instead of /usr/bin/sh

## 1.0.0-alpha.7

- Normalized line endings to LF

## 1.0.0-alpha.6

- Replaced execlineb with sh
- Removed debug info for ingress
- Added nginx to proxy requests for ingress

## 1.0.0-alpha.5

- Replaced bashio with execlineb in service script
- Added debug info for ingress

## 1.0.0-alpha.4

- Moved this changelog into the correct directory
- Added exec command to run script
- Fixed external hostname mapping

## 1.0.0-alpha.3

- Added this changelog
- Added all configured hostnames to allowlist
- Added avahi-daemon service

## 1.0.0-alpha.2

- Updated link to repository
- Fixed unescaped newlines causing container start to fail in run.sh

## 1.0.0-alpha.1

- Initial release