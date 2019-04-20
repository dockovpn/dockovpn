# docker-openvpn
Out of the box openvpn server docker image which you can use anywhere

## To run bare Ubuntu in docker
`docker run -it --rm --name ubuntu-openvpn --mount type=bind,source="$(pwd)"/scripts,target=/opt/teleport  ubuntu:16.04`

## To build docker-openvpn image
`docker build -t alekslitvinenk/openvpn:v0.0.1 .`

## To run docker-openvpn
`docker run -it --rm --name uvpn alekslitvinenk/openvpn:snapshot`

### Important notes:
In order to get openvpn machinery work in docker for mac you will need to assemple your own linux kernel build and substitute with it the build shipped wich docker for mac. There's a good account on how to do so:
https://medium.com/@notsinge/making-your-own-linuxkit-with-docker-for-mac-5c1234170fb1.

The reason being for that is the fact this default linux kernel build lacks some essentian modules. So we need to include them and configure according to our needs.