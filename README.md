# docker-openvpn
Out of the box openvpn server docker image which you can use anywhere

## To run bare Ubuntu in docker
`docker run -it --rm --name ubuntu-openvpn --mount type=bind,source="$(pwd)"/scripts,target=/opt/teleport  ubuntu:16.04`

## To build docker-openvpn image
`./build.sh`

## To run docker-openvpn
`docker run --privileged -it --rm --name uvpn alekslitvinenk/openvpn:snapshot`

## To build customized linuxkit image
`linuxkit build -format iso-efi -disable-content-trust docker-for-mac.yml`

### Important notes:
In order to get openvpn machinery work in docker for mac you will need to assemple your own linux kernel build and substitute with it the build shipped wich docker for mac. There's a good account on how to do so:
https://medium.com/@notsinge/making-your-own-linuxkit-with-docker-for-mac-5c1234170fb1.

The reason being for that is the fact this default linux kernel build lacks some essentian modules. So we need to include them and configure according to our needs.

By the time this manual was written i.e 20.04.2019 there was a major issue with [LinuxKit](https://github.com/linuxkit/linuxkit) tool, namely [3289](https://github.com/linuxkit/linuxkit/issues/3289) which had to deal with HyperKit version (v0.20180403-17-g3e954c) shipped with [Docker Desktop For Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac) version (Docker version 18.09.2, build 6247962). Fortunately, this issue was solved in the latest release of [Moby/HyperKit](https://github.com/moby/hyperkit). So, in order to test your LinuxKit build you will have to build HyperKit from sources and add it to your `PATH` in terminal wher you work with LinuxKit:
`export PATH=<hyperkit git repo>/build:$PATH`
