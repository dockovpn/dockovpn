<p align=center><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/logo-s.png"></p><br>

![Build](http://dockovpn.io:3000/build/docker-openvpn)
![Built](http://dockovpn.io:3000/built/docker-openvpn)

# 🔐Docker-OpenVPN
Out of the box stateless openvpn server docker image which starts in just a few seconds and doesn't require presistent storage.

## GitHub repo:
https://github.com/alekslitvinenk/docker-openvpn

## DockerHub repo:
https://hub.docker.com/r/alekslitvinenk/openvpn

# Video Guide 📹
<p align=center><a href="https://youtu.be/y5Dwakc6hMs"><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/video-cover-play.png"></a></p><br>

# Quick Start 🚀

### Prerequisites:
1. Any hardware or vps server running Linux. You should have administrative rights on this machine.
2. Docker installation on your server.
3. Public ip address assigned to your server.

## 1. Run docker-openvpn
If you know which ip address was assigned to your server, pass it in environment variable:<br>
```
docker run --privileged -it --rm --name dockovpn -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=<your_host_public_ip> alekslitvinenk/openvpn
```
If you don't know you server's ip adress, use the code below to launch you docker-openvpn:<br>
```
docker run --privileged -it --rm --name dockovpn -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=$(curl -s https://api.ipify.org) alekslitvinenk/openvpn
```

ℹ️ **Note:** `--privileged` flag is required to do manipulations with `iptables` and to setup a flag, that allows traffic forwarding in `sysctl.conf`.<br>
We will try to get rid of this flag in the future releases of docker-openvpn.<br><br>
If everything went well, you should be able to see the following output in your console:
```
Sun Jun  9 08:56:11 2019 Initialization Sequence Completed
Sun Jun  9 08:56:12 2019 Client.ovpn file has been generated
Sun Jun  9 08:56:12 2019 Config server started, download your client.ovpn config at http://example.com:8080/
Sun Jun  9 08:56:12 2019 NOTE: After you download you client config, http server will be shut down!
 ```
## 2. Get client configuration
Now, when your docker-openvpn is up and running you can go to `<your_host_public_ip>:8080` on your device and download ovpn client configuration.
As soon as you have your config file downloaded, you will see the following output in the console:<br>
```
Sun Jun  9 09:01:15 2019 Config http server has been shut down
```
Import `client.ovpn` into your favourite openvpn client. In most cases it should be enough to just doubleclick or tap on that file.


## 3. Connect to your docker-openvpn container
You should be able to see your newly added client configuration in the list of available configurations. Click on it, connection process should initiate and be established withing few seconds.

Congratulations, now you're all set and can safely browse the internet.

# Known issues
1. Currently docker-openvpn works only if the default network iterface on the host machine is called `eth0`. [Issue#15](https://github.com/alekslitvinenk/docker-openvpn/issues/15)

# Other resources
[Contrubition Guidelines](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CONTRIBUTING.md)<br>
[Code Of Conduct](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CODE_OF_CONDUCT.md)<br>
[License Agreement](https://github.com/alekslitvinenk/docker-openvpn/blob/master/LICENSE)
