# docker-openvpn
Out of the box openvpn server docker image which you can use anywhere

![IMG](docs/img/beta.png)

**WARNING:** This project is still a WIP project (WORK IN PROGRESS). We are constantly improving code quality and strive to provide best experience, nonetheless there are many things that have to be improved in order to make this project production ready. Please use this project at your own risk! Right now the major security concern is that all client and server keys as well as certificates are generated at build time and hence can be easily tempered. We will [FIX](https://github.com/alekslitvinenk/docker-openvpn/issues/2) it in future updates.

## To build docker-openvpn image
`./build.sh`

## To run docker-openvpn
`docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp alekslitvinenk/openvpn`<br>

**Note:** `--privileged` flag is required to do manipulations with `iptables`

## How to use
After docker container started it runs one-shot web-server at <public_ip>:8080. By going to this link you will be offered to download a zip archive containing client infrastrucure: certificate, key, ca and client configuration file (client.ovpn). In this fule change `localhost` server address to your actual server location. Import this configuration file to your favorite openvpn client and use it.
