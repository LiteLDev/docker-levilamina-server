FROM alpine:latest

WORKDIR /data

COPY --chmod=755 scripts/* /usr/local/bin/
RUN /usr/local/bin/build.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
