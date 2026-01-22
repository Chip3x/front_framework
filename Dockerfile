FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver

ARG ALLURE_VERSION=2.36.0

# System deps: Chromium + chromedriver + Java for Allure + basic tools
RUN apt-get update && apt-get install -y --no-install-recommends \
      chromium \
      chromium-driver \
      openjdk-17-jre-headless \
      curl \
      wget \
      unzip \
      ca-certificates \
      tzdata \
    && rm -rf /var/lib/apt/lists/*

# Install Allure Commandline
RUN curl -fsSL \
      "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz" \
      -o /tmp/allure.tgz \
    && mkdir -p /opt/allure \
    && tar -xzf /tmp/allure.tgz -C /opt/allure \
    && ln -sf "/opt/allure/allure-${ALLURE_VERSION}/bin/allure" /usr/bin/allure \
    && rm -f /tmp/allure.tgz

WORKDIR /usr/workspace

COPY requirements.txt /usr/workspace/requirements.txt
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -r requirements.txt

COPY . /usr/workspace
