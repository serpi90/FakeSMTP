FROM maven:3-jdk-8-slim as builder
RUN apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --assume-yes git
WORKDIR /build/
RUN git clone https://github.com/Nilhcem/FakeSMTP.git --branch=v2.0 .
RUN mvn package -DskipTests
    
FROM openjdk:8-jre-alpine
COPY --from=builder /build/target/fakeSMTP-2.0.jar /opt/fakeSMTP.jar
EXPOSE 25
WORKDIR /opt
VOLUME ["/var/mail"]
CMD java -jar /opt/fakeSMTP.jar --start-server --background --output-dir /var/mail --port 25
