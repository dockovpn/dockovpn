<p align=center><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/logo-s.png"></p><br>

# 🔐Docker-OpenVPN
Out of the box stateless openvpn server docker image which starts in a few seconds and doesn't require presistent storage.

## GitHub repo:
https://github.com/alekslitvinenk/docker-openvpn

## DockerHub repo:
https://hub.docker.com/r/alekslitvinenk/openvpn

# Quick Start 🚀

### Prerequisites:
1. Any phisical or vps server running Linux. You should have administrative rights on this machine.
2. Docker installation on your server.
3. Public ip address assigned to your server.

## 1. Run docker-openvpn
If you know which ip address was assigned to your server, pass it in environment variable:<br>
```
docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=<your_host_public_ip> alekslitvinenk/openvpn
```
If you don't know you server's ip adress, use the code below to launch you docker-openvpn:<br>
```
docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=$(curl -s https://api.ipify.org) alekslitvinenk/openvpn
```

ℹ️ **Note:** `--privileged` flag is required to do manipulations with `iptables` and to setup flag that allows trafic forwarding in `sysctl.conf`.<br>
We will try to get rid of this flag in the future releases of docker-openvpn.<br><br>
If everything went well, you should be able to see the following output in your console:
```
Sun Jun  9 08:56:11 2019 Initialization Sequence Completed
Sun Jun  9 08:56:12 2019 Client.ovpn file has been generated
Sun Jun  9 08:56:12 2019 Config server started, download your client.ovpn config at http://example.com:8080/
Sun Jun  9 08:56:12 2019 NOTE: After you download you client config, http server will be shut down!
 ```
## 2. Get client configuration
Now, as your docker-openvpn is up and running you can go to `<your_host_public_ip>:8080` on your desktop or laptop and download your client configuration.
As soon as you have your config file downloaded you will see the following output in the console:<br>
```
Sun Jun  9 09:01:15 2019 Config http server has been shut down
```
Import `client.ovpn` into your favourite openvpn client. In most cases it should be enough to just doubleclick on that file.


## 3. Connect to your docker-openvpn container
You should be able to see your newly added client configuration in the list of available configurations. Click on it, connection process should initiate and be established withing few seconds.

Congratulations, now you're all set and can safely browse the internet.

# Other resources
[Contrubition Guidelines](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CONTRIBUTING.md)<br>
[Code Of Conduct](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CODE_OF_CONDUCT.md)<br>
[License Agreement](https://github.com/alekslitvinenk/docker-openvpn/blob/master/LICENSE)
