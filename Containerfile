FROM ghcr.io/containerpak/mesa:main

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends kate sonnet6-plugins && \
    cpak-clean-junk
