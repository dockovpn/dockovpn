<p align=center><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/logo-s.png"></p><br>

<p align="center">
<a href="https://github.com/alekslitvinenk/docker-openvpn/blob/master/README.md">[English]</a>
<a href="https://github.com/alekslitvinenk/docker-openvpn/blob/master/docs/README_RU.md">[Русский]</a>
<br>

# 🔐DockOvpn

一个开箱即用、无状态、无需持久存储的 VPN服务器 Docker 镜像，可以在几秒钟内启动。要运行它，只需复制并粘贴下面的代码片段，并按照终端中的说明进行操作：


```bash
docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 80:8080/tcp \
--name dockovpn alekslitvinenk/openvpn
```


要获取更详细的信息，请参阅[快速入门](#-quick-start)教程或观看[视频](https://youtu.be/y5Dwakc6hMs)。

## 内容

[资源](#resources) \
[容器属性](#container-properties) \
[视频指南](#📺-video-guide) \
[快速入门](#🚀-quick-start) \
[持久化配置](#persisting-configuration) \
[另一种方法。使用 docker-compose 运行](#alternative-way-run-with-docker-compose) \
[其他资源](#other-resources)

## 资源

### 网站

<https://dockovpn.io>

### 社交媒体

| Name | URL |
| :--: | :-----: |
| LinkedIn | <https://www.linkedin.com/company/dockovpn> |
| Facebook | <https://www.facebook.com/dockovpn> |


### 软件存储库

| Name | URL |
| :--: | :-----: |
| GitHub | <https://github.com/dockovpn/dockovpn> |
| Docker Hub | <https://hub.docker.com/r/alekslitvinenk/openvpn> |

## 容器属性

<p align=center><a href="https://dockovpn.io" target="_blank"><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/container.svg"  width="150" height="110"></a></p>


### Docker 标签

| 标签    | 描述 |
| :----: | :---------: |
| `latest` | 每个新版本都会添加此标签，包括`v#.#.#`或`v#.#.#-regen-dh` |
| `v#.#.#` | 标准的固定发布版本，其中{1}是主版本号，{2}是次版本号，{3}是修订号。例如，`v1.1.0` |
| `v#.#.#-regen-dh` | 带有新生成的 Diffie Hellman 安全文件的发布版本。为了保持高安全性，此版本每小时生成一次。标签示例 - `v1.1.0-regen-dh` |
| `dev` | 包含来自活动开发分支 (master) 的最新更改的开发构建 |

### 环境变量

| 变量 | 描述 | 默认值 |
| :------: | :---------: | :-----------: |
| NET_ADAPTER | 主机上要使用的网络适配器 | eth0 |
| HOST_ADDR | 在客户端配置文件中广告的主机地址 | localhost |
| HOST_TUN_PORT | 在客户端配置文件中广告的隧道端口 | 1194 |
| HOST_TUN_PROTOCOL |                   隧道协议 (`tcp` 或 `udp`)             |      udp      |
| HOST_CONF_PORT | 用于下载客户端配置文件的主机上的HTTP端口 | 80 |

**⚠️ 注意：** 在提供的代码片段中，我们会广告适用于大多数用户的配置。我们不建议设置自定义 NET_ADAPTER 和 HOST_ADDR，除非您确实必须这样做。HOST_ADDR 会通过运行 shell 子命令`$(curl -s https://api.ipify.org)`自动确定。更常见的情况是，您可能想自定义 HOST_TUN_PORT、HOST_CONF_PORT 或 HOST_TUN_PROTOCOL。如果是这种情况，请使用下面的代码片段（不要忘记用您的值替换`<custom port>` 或 `<custom protocol>`）：

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


### 容器命令

在使用`docker run`命令运行容器后，可以使用`docker exec`命令执行附加命令。例如，`docker exec <container id> ./version.sh`。请查看下表以获取支持的命令的完整列表。

| 命令 | 描述 | 参数 | 示例 |
| :------: | :---------: | :--------: | :-----: |
| `./version.sh` | 输出完整的容器版本，例如 `Dockovpn v1.2.0` |  | `docker exec dockovpn ./version.sh` |
| `./genclient.sh` | 生成新的客户端配置 | `z` — 可选。将新生成的 client.ovpn 文件放入 client.zip 存档中。<br><br>`zp paswd` — 可选。将新生成的 client.ovpn 文件放入带有密码 `pswd` 的 client.zip 存档中。<br><br>`o` — 可选。将证书打印到输出中。<br><br>`oz` — 可选。将压缩后的证书打印到输出中。使用输出重定向。<br><br>`ozp paswd` — 可选。将加密的压缩证书打印到输出中。使用输出重定向。| `docker exec dockovpn ./genclient.sh`<br><br>`docker exec dockovpn ./genclient.sh z`<br><br>`docker exec dockovpn ./genclient.sh zp 123` <br><br>`docker exec dockovpn ./genclient.sh o > client.ovpn`<br><br>`docker exec dockovpn ./genclient.sh oz > client.zip` <br><br>`docker exec dockovpn ./genclient.sh ozp paswd > client.zip`| 
 | `./rmclient.sh` | 注销客户端证书，使其无法连接到给定的Dockovpn服务器。| 客户端 ID，例如 `vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp`. | `docker exec dockovpn ./rmclient.sh vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` |

## 📺 视频指南

<p align=center><a href="https://youtu.be/y5Dwakc6hMs"><img src="https://alekslitvinenk.github.io/docker-openvpn/assets/img/video-cover-play.png"></a></p><br>

## 🚀 快速入门

### 先决条件

1. 运行 Linux 的任何硬件或 VPS/VDS 服务器。您应该具有该机器的管理员权限。
2. 服务器上安装了 Docker。
3. 服务器分配了公共 IP 地址。

### 1. 运行 dockovpn

复制并粘贴以下命令以运行 docker-openvpn: <br>

```bash
docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 80:8080/tcp \
--name dockovpn alekslitvinenk/openvpn
```


**⚠️ 注意：** 此代码片段在附加模式下运行 Dockovpn，这意味着如果您关闭终端窗口，容器将停止运行。为了防止这种情况发生，您首先需要从 SSH 会话中分离容器。键入 `Ctrl+P Ctrl+Q`。

如果一切顺利，您应该在控制台中看到以下输出：


```bash
Sun Jun  9 08:56:11 2019 Initialization Sequence Completed
Sun Jun  9 08:56:12 2019 Client.ovpn file has been generated
Sun Jun  9 08:56:12 2019 Config server started, download your client.ovpn config at http://example.com:8080/
Sun Jun  9 08:56:12 2019 NOTE: After you download you client config, http server will be shut down!
 ```


### 2. 获取客户端配置

现在，当您的 dockovpn 正在运行时，您可以在您的设备上访问`<your_host_public_ip>:8080`，并下载 ovpn 客户端配置文件。
一旦您下载了配置文件，您将在控制台中看到以下输出：<br>

```bash
Sun Jun  9 09:01:15 2019 Config http server has been shut down
```

将`client.ovpn`导入到您喜欢的 OpenVPN 客户端中。在大多数情况下，只需双击或点击该文件即可。

### 3. 连接到您的 docker-openvpn 容器

您应该在可用配置列表中看到新添加的客户端配置。点击它，连接过程应在几秒钟内启动并建立连接。

恭喜，现在您已经准备就绪并可以安全地浏览互联网了。

## 持久化配置

可以通过卷存储来持久保存生成的文件。使用以下方式运行 Docker：


```bash
-v openvpn_conf:/opt/Dockovpn_data
```


## 另一种方法。使用 docker-compose 运行

有时使用 [docker-compose](https://docs.docker.com/compose/)更加方便。

要使用 docker-compose 运行 dockvpn，执行以下操作：

```bash
docker-compose up -d && \
docker-compose exec -d dockovpn wget -O /doc/Dockovpn/client.ovpn localhost:8080
```


运行此命令后，您可以在 `openvpn_conf` 文件夹中找到您的 `client.ovpn` 文件。

## 其他资源

[贡献指南](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CONTRIBUTING.md)<br>
[行为准则](https://github.com/alekslitvinenk/docker-openvpn/blob/master/CODE_OF_CONDUCT.md)<br>
[发布指南](https://github.com/alekslitvinenk/docker-openvpn/blob/master/docs/RELEASE_GUIDELINE.md)<br>
[许可协议](https://github.com/alekslitvinenk/docker-openvpn/blob/master/LICENSE)