FROM alpine:latest

COPY scripts /scripts
RUN ["sh", "/scripts/build.sh"]

WORKDIR /data
RUN chmod +x /scripts/entrypoint.sh
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
