<p align=center><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/logo-s.png"></p><br>

<p align="center">
<a href="https://github.com/alekslitvinenk/docker-openvpn/blob/master/README.md">[English]</a>
<a href="https://github.com/alekslitvinenk/docker-openvpn/blob/master/docs/README_RU.md">[Русский]</a>
<a href="https://github.com/alekslitvinenk/docker-openvpn/blob/master/docs/README_CN.md">[中国人]</a>
<br>

![Build Version](http://cicd.dockovpn.io/version/dockovpn)
![Build Status](http://cicd.dockovpn.io/build/dockovpn)
[![Tests Status](http://cicd.dockovpn.io/tests/dockovpn)](https://cicd.dockovpn.io/reports/dockovpn)
![Build Time](http://cicd.dockovpn.io/built/dockovpn)
[![Docker Pulls](https://img.shields.io/docker/pulls/alekslitvinenk/openvpn.svg)](https://hub.docker.com/r/alekslitvinenk/openvpn/)
[![Gitter chat](https://img.shields.io/badge/chat-on_gitter-50b6bb.svg)](https://gitter.im/docker-openvpn/community)
![GitHub](https://img.shields.io/github/license/dockovpn/dockovpn)

# 🔐DockOvpn
<p align=center><a href="https://techround.co.uk/vpns/11-dockovpn-solutions/" target="_blank"><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/VPN53-Badge-300x300.png"  width="198" height="198"></a></p><br>

Out of the box stateless VPN server docker image which starts in just a few seconds and doesn't require persistent storage. To get it running,  just copy & paste the snippet below and follow instructions in your terminal:

```bash
docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 80:8080/tcp \
--name dockovpn alekslitvinenk/openvpn
```

To get more detailed information, go to [Quick Start](#-quick-start) tutorial or watch [video](https://youtu.be/y5Dwakc6hMs).

## Supporting Dockovpn

Dockovpn is a team of cybersecurity experts developing leading edge projects in Networking, VPN, DevOPS and SecOPS domains. Project is supported entirely by volonteers.
If you'd like to help support the future of the project, please consider:
- Giving developer time (see [Contrubition Guidelines](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CONTRIBUTING.md))!
- Giving funds by becoming a sponsor on [GitHub](https://github.com/sponsors/dockovpn) or [OpenCollective](https://opencollective.com/dockovpn)!

## Content

[Resources](#resources) \
[Container properties](#container-properties) \
[Video Guide](#-video-guide) \
[Quick Start](#-quick-start) \
[Persisting configuration](#persisting-configuration) \
[Alternative way. Run with docker-compose](#alternative-way-run-with-docker-compose) \
[Other resources](#other-resources)

## Resources

### Real-time Chat
[Slack](https://dockovpn.slack.com) ([registration](https://join.slack.com/t/dockovpn/shared_invite/zt-200sz4vdi-w2qCtjlN7YIu~ZQPfph_Ow))

### Website

<https://dockovpn.io>

### Socail media

| Name | URL |
| :--: | :-----: |
| LinkedIn | <https://www.linkedin.com/company/dockovpn> |
| Facebook | <https://www.facebook.com/dockovpn> |

### Repos

| Name | URL |
| :--: | :-----: |
| GitHub | <https://github.com/dockovpn/dockovpn> |
| Docker Hub | <https://hub.docker.com/r/alekslitvinenk/openvpn> |

## Container properties

<p align=center><a href="https://dockovpn.io" target="_blank"><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/container.svg"  width="150" height="110"></a></p>

### Docker Tags

| Tag    | Description |
| :----: | :---------: |
| `latest` | This tag is added to every newly built version be that `v#.#.#` or `v#.#.#-regen-dh` |
| `v#.#.#` | Standard fixed release version, where {1} is _major version_, {2} - _minor_ and {3} is a _patch_. For instance, `v1.1.0` |
| `v#.#.#-regen-dh` | Release version with newly generated Deffie Hellman security file. In order to keep security high this version is generated every hour. Tag example - `v1.1.0-regen-dh` |
| `dev` | Development build which contains the most recent changes from the active development branch (master) |

### Environment variables

| Variable | Description | Default value |
| :------: | :---------: | :-----------: |
| NET_ADAPTER | Network adapter to use on the host machine | eth0 |
| HOST_ADDR | Host address override if the resolved address doesn't work | localhost |
| HOST_TUN_PORT | Tunnel port to advertise in the client config file | 1194 |
| HOST_TUN_PROTOCOL | Tunnel protocol (`tcp` or `udp`) | udp |
| HOST_CONF_PORT | HTTP port on the host machine to download the client config file | 80 |
| CRL_DAYS | CRL days until expiration, i.e. invalid for revocation checking | 3650 |

**⚠️ Note:** In the provided code snippet we advertise the configuration suitable for the most users. We don't recommend setting custom
NET_ADAPTER and HOST_ADDR unless you absolutely have to. Now host address is resolved automatically when container starts..
More often you'd like to customize HOST_TUN_PORT, HOST_CONF_PORT or HOST_TUN_PROTOCOL. If this is the case, use the snippet below (dont forget to replace `<custom port>` and `<custom protocol>`  with your values):

```shell
DOCKOVPN_CONFIG_PORT=<custom port>
DOCKOVPN_TUNNEL_PORT=<custom port>
DOCKOVPN_TUNNEL_PROTOCOL=<custom protocol>
docker run -it --rm --cap-add=NET_ADMIN \
-p $DOCKOVPN_TUNNEL_PORT:1194/$DOCKOVPN_TUNNEL_PROTOCOL -p $DOCKOVPN_CONFIG_PORT:8080/tcp \
-e HOST_CONF_PORT="$DOCKOVPN_CONFIG_PORT" \
-e HOST_TUN_PORT="$DOCKOVPN_TUNNEL_PORT" \
-e HOST_TUN_PROTOCOL="$DOCKOVPN_TUNNEL_PROTOCOL" \
--name dockovpn alekslitvinenk/openvpn
```

### Container options

| Short name | Long name | Description |
| :-: | :---: | :-----: |
| `-r` | `--regenerate` | Regenerates PKI and DH file |
| `-n` | `--noop` | Initialise container, but don's start VPN server |
| `-q` | `--quit` | Quit after container was initialized |
| `-s` | `--skip` | Skip client generation on first start |

**⚠️ Note:** We strongly recommend always run your container with `-r` option, even though it will take container a bit longer to start. In future releases we will apply this option by default:

```bash
docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 80:8080/tcp \
--name dockovpn alekslitvinenk/openvpn -r
```

### Container commands

After container was run using `docker run` command, it's possible to execute additional commands using `docker exec` command. For example, `docker exec <container id> ./version.sh`. See table below to get the full list of supported commands.

| Command  | Description | Parameters | Example |
| :------: | :---------: | :--------: | :-----: |
| `./version.sh` | Outputs full container version, i.e `Dockovpn v1.2.0` |  | `docker exec dockovpn ./version.sh` |
| `./genclient.sh` | Generates new client configuration | `z` — Optional. Puts newly generated client.ovpn file into client.zip archive.<br><br>`zp paswd` — Optional. Puts newly generated client.ovpn file into client.zip archive with password `pswd` <br><br>`o` — Optional. Prints cert to the output. <br><br>`oz` — Optional. Prints zipped cert to the output. Use with output redirection. <br><br>`ozp paswd` — Optional. Prints encrypted zipped cert to the output. Use with output redirection.  <br><br>`n profile_name` — Optional. Use specified profile_name parameter instead of random id. Prints client.ovpn to the output<br><br>`np profile_name` — Optional. Use specified profile_name parameter instead of random id and protects by password asked by stdin. Password refers to the connection and it will be asked during connection stage. Prints client.ovpn to the output | `docker exec dockovpn ./genclient.sh`<br><br>`docker exec dockovpn ./genclient.sh z`<br><br>`docker exec dockovpn ./genclient.sh zp 123` <br><br>`docker exec dockovpn ./genclient.sh o > client.ovpn`<br><br>`docker exec dockovpn ./genclient.sh oz > client.zip` <br><br>`docker exec dockovpn ./genclient.sh ozp paswd > client.zip`<br><br>`docker exec dockovpn ./genclient.sh n profile_name`<br><br>`docker exec -ti dockovpn ./genclient.sh np profile_name` |
| `./rmclient.sh` | Revokes client certificate thus making him/her anable to connect to given Dockovpn server. | Client Id, i.e `vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` | `docker exec dockovpn ./rmclient.sh vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` |
| `./listconfigs.sh` | List all generated available config IDs |  | `docker exec dockovpn ./listconfigs.sh` |
| `./getconfig.sh` | Return previously generated config by client ID | Client Id, i.e `vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` | `docker exec dockovpn./getconfig.sh vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` |

 **⚠️ Note:** If you generated a new client configuration with custom name e.g `dockovpn exec ./genclient.sh n customname` and then chose to remove this config using `dockovpn exec ./rmclient.sh customname`, the client certificate is revoked permanently in this server, therefore, you cannot create client configuration with the same name again. Doing so will result in error `Sat Oct 28 10:05:17 2023 Client with this id [customname] already exists`.

## 📺 Video Guide

<p align=center><a href="https://youtu.be/y5Dwakc6hMs"><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/video-cover-play.png"></a></p><br>

## 🚀 Quick Start

### Prerequisites

1. Any hardware or vps/vds server running Linux. You should have administrative rights on this machine.
2. Docker installation on your server.
3. Public ip address assigned to your server.

### 1. Run dockovpn

Copy & paste the following command to run docker-openvpn:<br>

```bash
docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 80:8080/tcp \
--name dockovpn alekslitvinenk/openvpn
```

**⚠️ Note:** This snippet runs Dockovpn in attached mode, which means if you close your terminal window, container will be stopped.
To prevent this from happening, you first need to detach container from ssh session. Type `Ctrl+P Ctrl+Q`.

If everything went well, you should be able to see the following output in your console:

```bash
Sun Jun  9 08:56:11 2019 Initialization Sequence Completed
Sun Jun  9 08:56:12 2019 Client.ovpn file has been generated
Sun Jun  9 08:56:12 2019 Config server started, download your client.ovpn config at http://example.com:8080/
Sun Jun  9 08:56:12 2019 NOTE: After you download you client config, http server will be shut down!
 ```

### 2. Get client configuration

Now, when your dockovpn is up and running you can go to `<your_host_public_ip>:8080` on your device and download ovpn client configuration.
As soon as you have your config file downloaded, you will see the following output in the console:<br>

```bash
Sun Jun  9 09:01:15 2019 Config http server has been shut down
```

Import `client.ovpn` into your favourite openvpn client. In most cases it should be enough to just doubleclick or tap on that file.

### 3. Connect to your docker-openvpn container

You should be able to see your newly added client configuration in the list of available configurations. Click on it, connection process should initiate and be established within few seconds.

Congratulations, now you're all set and can safely browse the internet.

## Persisting configuration

There's a possibility to persist generated files in volume storage. Run docker with

```bash
-v openvpn_conf:/opt/Dockovpn_data
```

## Alternative way. Run with docker-compose

Sometimes it is more convenient to use [docker-compose](https://docs.docker.com/compose/).

To run dockvpn with docker-compose run:

```bash
docker-compose up -d && \
docker-compose exec -d dockovpn wget -O /doc/Dockovpn/client.ovpn localhost:8080
```

After run this command you can find your `client.ovpn` inside `openvpn_conf` folder.

## Other resources

[Contrubition Guidelines](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CONTRIBUTING.md)<br>
[Code Of Conduct](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CODE_OF_CONDUCT.md)<br>
[Release Guideline](https://github.com/alekslitvinenk/docker-openvpn/blob/master/docs/RELEASE_GUIDELINE.md)<br>
[License Agreement](https://github.com/alekslitvinenk/docker-openvpn/blob/master/LICENSE)
