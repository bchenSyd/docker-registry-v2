FROM alpine:3.4

RUN set -ex \
    && apk add --no-cache ca-certificates apache2-utils

COPY ./registry/registry /bin/registry
COPY ./registry/config-example.yml /etc/docker/registry/config.yml

# this is the storage path
VOLUME ["/var/lib/registry"]

EXPOSE 5000

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# CMD ["executable","param1","param2"] (exec form, this is the preferred form)
# CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
# CMD command param1 param2 (shell form)
CMD ["/etc/docker/registry/config.yml"]