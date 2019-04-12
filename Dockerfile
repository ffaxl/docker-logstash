FROM openjdk:8-jre-slim
MAINTAINER Evgeniy Slizevich <evgeniy@slizevich.net>

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    && addgroup --system logstash \
    && adduser --gecos '&' --shell /bin/bash --ingroup logstash --system logstash \
    && mkdir /logstash \
    && wget -qO - https://artifacts.elastic.co/downloads/logstash/logstash-7.0.0.tar.gz | tar xzf - --strip-components=1 -C /logstash \
    && rm /logstash/config/startup.options \
    && mv /logstash/config /logstash/config.orig \
    && mkdir /logstash/config \
    && chown -R logstash:logstash /logstash

COPY entry /

VOLUME /logstash/config
VOLUME /logstash/pipeline
VOLUME /logstash/data
VOLUME /logstash/logs

ENTRYPOINT /entry
