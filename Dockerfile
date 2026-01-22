FROM python:3.12-alpine3.23

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ALLURE_VERSION=2.36.0

# System deps:
# - chromium + chromedriver for UI tests
# - openjdk for Allure CLI
# - fonts/libs for stable headless Chromium
RUN apk add --no-cache \
      bash \
      curl \
      tar \
      tzdata \
      openjdk17-jre-headless \
      chromium \
      chromium-chromedriver \
      nss \
      freetype \
      harfbuzz \
      ttf-freefont \
    && python -m pip install --upgrade pip

# Install Allure Commandline (new version to avoid "titlePath" schema errors)
RUN curl -fsSL -o /tmp/allure.tgz \
      "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz" \
    && mkdir -p /opt \
    && tar -xzf /tmp/allure.tgz -C /opt \
    && ln -sf "/opt/allure-${ALLURE_VERSION}/bin/allure" /usr/local/bin/allure \
    && rm -f /tmp/allure.tgz

# Ensure chromium command exists under common names
RUN if [ -x /usr/bin/chromium-browser ] && [ ! -e /usr/bin/chromium ]; then ln -s /usr/bin/chromium-browser /usr/bin/chromium; fi \
    && if [ -x /usr/bin/chromium ] && [ ! -e /usr/bin/chromium-browser ]; then ln -s /usr/bin/chromium /usr/bin/chromium-browser; fi

WORKDIR /usr/workspace

COPY requirements.txt /usr/workspace/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Optional (keeps image runnable without bind mount; harmless with bind mount)
COPY . /usr/workspace
