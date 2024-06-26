# 使用适合 ARM 架构的最新 Alpine 镜像
FROM arm32v7/alpine:latest

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

# System settings. User normally shouldn't change these parameters
ENV APP_NAME Dockovpn
ENV APP_INSTALL_PATH /opt/${APP_NAME}
ENV APP_PERSIST_DIR /opt/${APP_NAME}_data

# Configuration settings with default values
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

# 设置官方包仓库地址，并逐步输出日志
# RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories && \
#    echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
#    echo "Repositories updated successfully" || { cat /var/log/apk.log; exit 1; }

# 如果在中国大陆，使用国内镜像源
 RUN echo "https://mirrors.aliyun.com/alpine/latest-stable/main" > /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/latest-stable/community" >> /etc/apk/repositories && \
    echo "Repositories updated successfully with Aliyun mirror" || { cat /var/log/apk.log; exit 1; }

# 安装所需的软件包，并设置 Easy-RSA 和 OpenVPN
RUN apk update && \
    apk add --no-cache openvpn easy-rsa bash netcat-openbsd zip curl dumb-init && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/bin/easyrsa && \
    mkdir -p ${APP_PERSIST_DIR} && \
    cd ${APP_PERSIST_DIR} && \
    easyrsa init-pki && \
    easyrsa gen-dh && \
    cp pki/dh.pem /etc/openvpn && \
    cp ${APP_INSTALL_PATH}/config/server.conf /etc/openvpn/server.conf

EXPOSE 1194/${HOST_TUN_PROTOCOL}
EXPOSE 8080/tcp

VOLUME [ "/opt/Dockovpn_data" ]

ENTRYPOINT [ "dumb-init", "./start.sh" ]
CMD [ "" ]
