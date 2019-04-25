FROM ubuntu:16.04

COPY scripts /opt/teleport
COPY config /opt/teleport/config

RUN /opt/teleport/buildtime/init.sh

ENTRYPOINT [ "/opt/teleport/runtime/start.sh" ]