FROM alpine:3.14.1

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

ENV APP_NAME Dockovpn
ENV APP_INSTALL_PATH /opt/${APP_NAME}
ENV APP_PERSIST_DIR /opt/${APP_NAME}_data
ENV EASYRSA_PKI ${APP_INSTALL_PATH}/config/pki

WORKDIR ${APP_INSTALL_PATH}

COPY scripts .
COPY config ./config
COPY VERSION ./config

RUN apk add --no-cache openvpn easy-rsa bash netcat-openbsd zip dumb-init && \
    mkdir -p ${APP_PERSIST_DIR} && \
    cd ${APP_PERSIST_DIR} && \
    #/usr/share/easy-rsa/easyrsa init-pki && \
    cp -r ${APP_INSTALL_PATH}/config/pki . && \
    /usr/share/easy-rsa/easyrsa gen-dh && \
    # DH parameters of size 2048 created at /usr/share/easy-rsa/pki/dh.pem
    # Copy DH file
    cp ${APP_INSTALL_PATH}/config/pki/dh.pem /etc/openvpn && \
    cp pki/ca.crt /etc/openvpn && \
    cp pki/server.crt /etc/openvpn && \
    cp pki/private/server.key /etc/openvpn && \
    # Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile
    cd ${APP_INSTALL_PATH} && \
    cp config/server.conf /etc/openvpn/server.conf


#EXPOSE 1194/udp
EXPOSE 8080/tcp

#VOLUME [ "/opt/Dockovpn_data" ]

ENTRYPOINT [ "dumb-init", "./start.sh" ]
CMD [ "" ]
