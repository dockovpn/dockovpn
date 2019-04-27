FROM alpine

LABEL maintainer="Alexander Litvinenko <array.shift@yahoo.com>"

ENV APP_NAME teleport
ENV APP_INSTALL_PATH /opt/${APP_NAME}

COPY scripts ${APP_INSTALL_PATH}
COPY config ${APP_INSTALL_PATH}/config

RUN ${APP_INSTALL_PATH}/buildtime/init.sh

#ENTRYPOINT ["bin/sh", "-c", "$APP_INSTALL_PATH/runtime/start.sh" ]