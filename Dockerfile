FROM python:3.12-alpine3.23

# System deps (Chromium + driver, Java for Allure, curl/tar/wget, bash for Allure CLI script)
RUN apk add --no-cache \
      chromium \
      chromium-chromedriver \
      tzdata \
      openjdk11-jre \
      bash \
      curl \
      tar \
      wget \
      ca-certificates \
  && update-ca-certificates

# Allure CLI
ARG ALLURE_VERSION=2.13.8
RUN curl -fsSL -o /tmp/allure.tgz \
      "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz" \
  && tar -xzf /tmp/allure.tgz -C /opt/ \
  && ln -sf "/opt/allure-${ALLURE_VERSION}/bin/allure" /usr/bin/allure \
  && rm -f /tmp/allure.tgz

WORKDIR /usr/workspace

COPY ./requirements.txt /usr/workspace
RUN python -m pip install --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt
