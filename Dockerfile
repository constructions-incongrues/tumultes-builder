# syntax=docker/dockerfile:1.4
# Based on https://github.com/n3wjack/faircamp-docker

FROM --platform=linux/amd64 python:3.13-slim-bookworm AS base

# Install dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN apt-get update && \
    apt-get install --no-install-recommends --yes ffmpeg libvips42 curl

# Install Faircamp
ARG VERSION=1.4.0

RUN mkdir /fc
WORKDIR /fc

RUN curl -Lvk https://simonrepp.com/faircamp/packages/faircamp_$VERSION-1+deb12_amd64.deb -o faircamp.deb

RUN dpkg --install /fc/faircamp.deb && \
    apt-get install --no-install-recommends --yes -f && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /fc/faircamp.deb

# Setup the working folder.
RUN mkdir /data
WORKDIR /data

# Run Faircamp. Any arguments passed to docker will be passed to Faircamp.
ENTRYPOINT ["faircamp"]