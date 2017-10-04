# Dockerfile
FROM alpine:latest

MAINTAINER Fabrique-IT

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [""]
