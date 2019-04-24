FROM ubuntu:16.04

COPY scripts /opt/teleport
COPY config /opt/teleport/config

RUN /opt/teleport/buildtime/build.sh

CMD ["chmod", "+x", "/opt/teleport/runtime/init.sh" ]