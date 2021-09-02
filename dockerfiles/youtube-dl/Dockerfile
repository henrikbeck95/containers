FROM alpine:latest
MAINTAINER Henrik Beck <henrikbeck95@gmail.com>

RUN set -x && apk add --no-cache \
	youtube-dl && \
	mkdir /downloads && \
	chmod a+rw /downloads && \
	mkdir /.cache && \
	chmod 777 /.cache

WORKDIR /downloads

VOLUME ["/downloads"]

ENTRYPOINT ["youtube-dl"]
CMD ["--help"]
