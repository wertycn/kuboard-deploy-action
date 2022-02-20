FROM alpine:3.10
COPY run.sh /opt/entrypoint.sh
RUN apk update \
    && apk add --no-cache bash curl jq  \
    && rm -rf /var/cache/apk/* \
    && chmod 765 -R /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

