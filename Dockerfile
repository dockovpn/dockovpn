FROM alpine:3.14.1

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

ENV APP_NAME Dockovpn
ENV APP_INSTALL_PATH /opt/${APP_NAME}
ENV APP_PERSIST_DIR /opt/${APP_NAME}_data
ENV NET_ADAPTER eth0

WORKDIR ${APP_INSTALL_PATH}

COPY scripts .
COPY config ./config
COPY VERSION ./config

RUN apk add --no-cache python3 py-pip openvpn easy-rsa bash netcat-openbsd zip dumb-init && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/bin/easyrsa && \
    mkdir -p ${APP_PERSIST_DIR} && \
    mkdir -p /build && \
    cd /build && \
    easyrsa init-pki && \
    easyrsa gen-dh && \
    # DH parameters of size 2048 created at /usr/share/easy-rsa/pki/dh.pem
    # Copy DH file
    cp pki/dh.pem /etc/openvpn && \
    # Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile
    cd ${APP_INSTALL_PATH} && \ 
    pip install cookiecutter && \
    mkdir -p /etc/openvpn


EXPOSE 1194/udp
EXPOSE 8080/tcp

VOLUME [ "/opt/Dockovpn_data" ]

ENTRYPOINT [ "dumb-init", "./start.sh" ]
CMD [ "" ]
