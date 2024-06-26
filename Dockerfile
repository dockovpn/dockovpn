# FROM alpine:3.14.1
# 使用适用于 ARM 架构的 Alpine 镜像
FROM arm32v7/alpine:3.14.1

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

# System settings. User normally shouldn't change these parameters
# 系统设置。通常用户不应更改这些参数
ENV APP_NAME Dockovpn
ENV APP_INSTALL_PATH /opt/${APP_NAME}
ENV APP_PERSIST_DIR /opt/${APP_NAME}_data

# Configuration settings with default values
# 配置设置的默认值
ENV NET_ADAPTER eth0
ENV HOST_ADDR ""
ENV HOST_TUN_PORT 1194
ENV HOST_CONF_PORT 80
ENV HOST_TUN_PROTOCOL udp
ENV CRL_DAYS 3650

WORKDIR ${APP_INSTALL_PATH}

COPY scripts .
COPY config ./config
COPY VERSION ./config

# 安装所需的软件包，并设置 Easy-RSA 和 OpenVPN
RUN apk add --no-cache openvpn easy-rsa bash netcat-openbsd zip curl dumb-init
RUN ln -s /usr/share/easy-rsa/easyrsa /usr/bin/easyrsa
RUN mkdir -p ${APP_PERSIST_DIR}
RUN cd ${APP_PERSIST_DIR} && easyrsa init-pki && easyrsa gen-dh
RUN cp ${APP_PERSIST_DIR}/pki/dh.pem /etc/openvpn
RUN cp ${APP_INSTALL_PATH}/config/server.conf /etc/openvpn/server.conf


EXPOSE 1194/${HOST_TUN_PROTOCOL}
EXPOSE 8080/tcp

VOLUME [ "/opt/Dockovpn_data" ]

ENTRYPOINT [ "dumb-init", "./start.sh" ]
CMD [ "" ]
