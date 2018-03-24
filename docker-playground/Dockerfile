FROM node:9.5.0-alpine
RUN mkdir -p /verdaccio/storage /verdaccio/conf
RUN addgroup -S verdaccio && adduser -S -G verdaccio   verdaccio 

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["entrypoint.sh"]