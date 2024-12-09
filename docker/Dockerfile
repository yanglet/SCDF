FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \

RUN sh -c "mkdir -p /SCDF"

COPY ../../SCDF/* /SCDF/*

WORKDIR SCDF

RUN ./gradlew clean bootjar
RUN cp ./build/libs/*.jar app.jar

CMD ["java", "-jar", "app.jar"]