# 🔐Docker-OpenVPN
Out of the box stateless openvpn server docker image which starts in less than 2 seconds and doesn't require presistent storage.

![IMG](https://alekslitvinenk.github.io/docker-openvpn/assets/img/logo-s.png)

## GitHub repo:
https://github.com/alekslitvinenk/docker-openvpn

## DockerHub repo:
https://hub.docker.com/r/alekslitvinenk/openvpn

⚠️ **WARNING:** This project is still a WIP project (WORK IN PROGRESS). We are constantly improving code quality and strive to provide best experience, nonetheless there are many things that have to be improved in order to make this project production ready. Please use this project at your own risk!

# Quick Start 🚀

### Prerequisites:
1. Any phisical or vps server running linux. You should have administrative privileges on this machine.
2. Docker installation on your server.
3. Public ip address assigned to your server.

## 1. Run docker-openvpn
If you know which ip address was assigned to your server, pass it in environment variable:<br>
`docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=<your_host_public_ip> alekslitvinenk/openvpn cz`.<br>
If you don't know you server's ip adress, use the code below to launch you docker-openvpn:<br>
`docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=$(curl -s https://api.ipify.org) alekslitvinenk/openvpn cz`

ℹ️ **Note:** `--privileged` flag is required to do manipulations with `iptables` and to setup flag that allows trafic forwarding in `sysctl.conf`.<br>
We will try to get rid of this flag in the future releases of docker-openvpn.<br><br>
If everything went well, you should be able to see the following output in your console:
```
Write out database with 1 new entries
Data Base Updated
  adding: client/ (stored 0%)
  adding: client/client.key (deflated 23%)
  adding: client/ca.crt (deflated 25%)
  adding: client/client.ovpn (deflated 23%)
  adding: client/client.crt (deflated 45%)
 ```
## 2. Get client configuration
Now, as your docker-openvpn is up and running you can go to `<your_host_public_ip>:8080` on your desktop or laptop and download zip archive with client files. Unzip archive. Import `client.ovpn` into your favourite openvpn client. In most cases it should be enough to just doubleclick on that file.

## 3. Connect to your docker-openvpn container
You should be able to see your newly added client configuration in the list of available configurations. Click on it, connection process should initiate. Watch you docker-openvpn output, you should see something like this:
```
bash-4.4# Fri May 10 12:26:46 2019 172.17.0.1:53181 TLS: Initial packet from [AF_INET]172.17.0.1:53181, sid=a802dd8b 9bc5eb8d
Fri May 10 12:26:47 2019 172.17.0.1:53181 VERIFY OK: depth=1, CN=Easy-RSA CA
Fri May 10 12:26:47 2019 172.17.0.1:53181 VERIFY OK: depth=0, CN=client
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_VER=2.4.6
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_PLAT=mac
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_PROTO=2
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_NCP=2
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_LZ4=1
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_LZ4v2=1
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_LZO=1
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_COMP_STUB=1
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_COMP_STUBv2=1
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_TCPNL=1
Fri May 10 12:26:47 2019 172.17.0.1:53181 peer info: IV_GUI_VER="net.tunnelblick.tunnelblick_5180_3.7.8__build_5180)"
Fri May 10 12:26:47 2019 172.17.0.1:53181 Control Channel: TLSv1.2, cipher TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384, 2048 bit RSA
Fri May 10 12:26:47 2019 172.17.0.1:53181 [client] Peer Connection Initiated with [AF_INET]172.17.0.1:53181
Fri May 10 12:26:47 2019 client/172.17.0.1:53181 MULTI_sva: pool returned IPv4=10.8.0.6, IPv6=(Not enabled)
Fri May 10 12:26:47 2019 client/172.17.0.1:53181 MULTI: Learn: 10.8.0.6 -> client/172.17.0.1:53181
Fri May 10 12:26:47 2019 client/172.17.0.1:53181 MULTI: primary virtual IP for client/172.17.0.1:53181: 10.8.0.6
Fri May 10 12:26:48 2019 client/172.17.0.1:53181 PUSH: Received control message: 'PUSH_REQUEST'
Fri May 10 12:26:48 2019 client/172.17.0.1:53181 SENT CONTROL [client]: 'PUSH_REPLY,redirect-gateway def1 bypass-dhcp,dhcp-option DNS 208.67.222.222,dhcp-option DNS 208.67.220.220,route 10.8.0.1,topology net30,ping 10,ping-restart 120,ifconfig 10.8.0.6 10.8.0.5,peer-id 0,cipher AES-256-GCM' (status=1)
Fri May 10 12:26:48 2019 client/172.17.0.1:53181 Data Channel: using negotiated cipher 'AES-256-GCM'
Fri May 10 12:26:48 2019 client/172.17.0.1:53181 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Fri May 10 12:26:48 2019 client/172.17.0.1:53181 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
```
Congratulations, now you're all set and can safely browse the internet.
