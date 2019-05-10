# 🔐Docker-OpenVPN
Out of the box stateless openvpn server docker image which starts in less than 2 seconds and doesn't require presistent storage.

![IMG](https://alekslitvinenk.github.io/docker-openvpn/assets/img/beta.png)

## GitHub repo:
https://github.com/alekslitvinenk/docker-openvpn

## DockerHub repo:
https://hub.docker.com/r/alekslitvinenk/openvpn

⚠️ **WARNING:** This project is still a WIP project (WORK IN PROGRESS). We are constantly improving code quality and strive to provide best experience, nonetheless there are many things that have to be improved in order to make this project production ready. Please use this project at your own risk!

# Quick Start

## 1. Run docker-openvpn
`docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp alekslitvinenk/openvpn`<br>

ℹ️ **Note:** `--privileged` flag is required to do manipulations with `iptables` and to setup flag that allows trafic forwarding in `sysctl.conf`.

## 2. Connect to your docker-openvpn container
After docker-openvpn container has started it runs one-shot web-server at <br> `<your_host>:8080`.<br> By going to this link you will be offered to download a zip archive containing client infrastrucure: certificate, key, ca and client configuration file (client.ovpn). In this file change `localhost` server address to your actual server location. Import this configuration file to your favorite openvpn client and use it.
