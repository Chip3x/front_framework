FROM python:3.12.0a4-alpine3.17
# update apk repo
RUN echo "https://dl-4.alpinelinux.org/alpine/v3.10/main" >> /etc/apk/repositories && \
    echo "https://dl-4.alpinelinux.org/alpine/v3.10/community" >> /etc/apk/repositories

# install chromedriver
RUN apk update
RUN apk add --no-cache chromium chromium-chromedriver tzdata

# Get all the prereqs
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk

RUN apk add --no-cache openjdk17-jre curl tar \
 && curl -fsSL -o /tmp/allure.tgz \
    https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz \
 && tar -xzf /tmp/allure.tgz -C /opt \
 && ln -sf /opt/allure-${ALLURE_VERSION}/bin/allure /usr/local/bin/allure \
 && rm -f /tmp/allure.tgz

WORKDIR /usr/workspace

# Copy the dependencies file to the working directory
COPY ./requirements.txt /usr/workspace

# Install Python dependencies
RUN pip3 install -r requirements.txt