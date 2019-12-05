FROM alpine:3.10.2

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

ENV APP_NAME dockovpn
ENV APP_INSTALL_PATH /opt/${APP_NAME}

WORKDIR ${APP_INSTALL_PATH}

COPY scripts .
COPY config ./config

RUN apk add --no-cache openvpn easy-rsa bash netcat-openbsd zip && \
    /usr/share/easy-rsa/easyrsa init-pki && \
    /usr/share/easy-rsa/easyrsa gen-dh && \
    # DH parameters of size 2048 created at /usr/share/easy-rsa/pki/dh.pem
    # Copy DH file
    cp pki/dh.pem /etc/openvpn && \
    # Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile
    cp config/server.conf /etc/openvpn/server.conf

EXPOSE 1194/udp
EXPOSE 8080/tcp

ENTRYPOINT [ "./start.sh" ]
CMD [ "c" ]