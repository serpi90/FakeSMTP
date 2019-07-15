FROM alpine as download

WORKDIR /tmp

ADD http://nilhcem.github.com/FakeSMTP/downloads/fakeSMTP-latest.zip .
RUN set -eu; \
    apk add --update unzip; \
    unzip fakeSMTP-latest.zip; \
    rm fakeSMTP-latest.zip; \
    mv /tmp/fakeSMTP*.jar /opt/fakeSMTP.jar

FROM openjdk:8-jre-alpine
COPY --from=download /opt/fakeSMTP.jar /opt/fakeSMTP.jar

EXPOSE 25
WORKDIR /opt
VOLUME ["/var/mail"]
CMD java -jar /opt/fakeSMTP.jar --start-server --background --output-dir /var/mail --port 25
