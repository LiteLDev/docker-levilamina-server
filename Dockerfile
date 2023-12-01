FROM alpine:latest

COPY scripts /scripts
RUN ["sh", "/scripts/build.sh"]

WORKDIR /data
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
