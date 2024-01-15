
# FROM openjdk:11-buster
FROM openjdk:22-bookworm

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y curl unzip graphviz \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/schemaspy/schemaspy/releases/download/v6.2.4/schemaspy-6.2.4.jar -o /tmp/schemaspy.jar \
    && curl -L https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar -o /tmp/mysql-connector-j.jar