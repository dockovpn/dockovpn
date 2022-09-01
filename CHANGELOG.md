# Change log

## v1.9.0

- Adds possibility to customise HTTP and tunnel port (Issue #170)

## v1.8.0

- Add a possibility to specify network adapter (Issue #15)

## v1.7.1

- Update badges in README to use new CICD server

## v1.7.0

- Introduce client revokation API
- Change LICENSE to GPLv2

## v1.6.5

- Improve Ru translation
- Fix README tipos
- Fix clientgen script to print mesage when file is actually generated
- Update base image version to Alpine 3.14.1

## v1.6.4

- Pull latest version of dockovpn-it before running tests #125

## v1.6.3

- Make test-runner container use volume to share config between server and clients
- Make test-runner container use host network to download configs from Dockovpn container
- Make test-runner container non-persistent (add --rm flag)

## v1.6.2

- Fix failing build

## v1.6.1

- Replaced a bunch of shell scripts with a single Makefile
- Added integration tests

## v1.6.0

- Add support for iOS client Passepartout (<https://passepartoutvpn.app/>)

## v1.5.0

- Add volume support (by romansavrulin)
- Add option to output client config in ternminal (by AngryJKirk)
- Add docker-compose file (by optimistic5)

## v1.4.1

-

## v1.4.0

- Add possibility to create additional users #78

## v1.3.4

-

## v1.3.3

- Update README russian version

## v1.3.2

- Add integration with Travis

## v1.3.1

-

## v1.3.0

- Add version badge
- Upgrade base image to Alpine Linux 3.11
- Replace APP_VERSION with VERSION file containing app version

## v1.2.2

- Update verson info

## v1.2.1

- Update documentation

## v1.2.0

- Add dev tag with development builds #54
- Improve security adding tls and stronger ciphers #51
- Make docker container quit when it receives SIGTERM #34
- Add printing app version on start and ./version.sh script to get version of running container

## v1.1.1

- Add info about tags and versioning

## v1.1.0

- Remove interactive mode #31
- Rename APP_NAME to dockovpn #35
- Improve versioning system #46

## v1.0.1

- Fixed: Http server doesn't always work on a new host first time #27
- Fixed: Use newer version of the base image #28
- Serve config via default HTTP port 80 #29
