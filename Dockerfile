FROM openjdk:8-jre-alpine
MAINTAINER Evgeniy Slizevich <evgeniy@slizevich.net>

ENV LANG=C.UTF-8

RUN apk add --no-cache \
        bash \
        ca-certificates \
        wget \
        tar \
    && update-ca-certificates \
    && addgroup -S logstash \
    && adduser -g '&' -s /bin/bash -G logstash -S logstash \
    && mkdir /logstash \
    && wget -qO - `wget -qO - https://www.elastic.co/downloads/logstash | grep -Eo 'https://.*?/logstash-.*?.tar.gz'` | tar xzf - --strip-components=1 -C /logstash \
    && rm /logstash/config/startup.options \
    && mv /logstash/config /logstash/config.orig \
    && mkdir /logstash/config \
    && cd /logstash && bin/logstash-plugin install logstash-filter-multiline

COPY entry /

VOLUME /logstash/config
VOLUME /logstash/pipeline
VOLUME /logstash/data
VOLUME /logstash/logs

ENTRYPOINT /entry
