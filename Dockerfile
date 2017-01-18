FROM ubuntu:16.10
MAINTAINER Sebastian Picklum <sp@php.net>

# Upgrade OS to latest
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-get install -y   \
			apt-utils \
			bash \
			curl \
			dirmngr \
			build-essential \
			gcc \
			gpg \
			libc-dev \
			wget



# Use tini as Init processes
ENV TINI_VERSION=0.13.2
RUN curl -fsSL "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini" -o /sbin/tini \
 && curl -fsSL "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini.asc" -o /tini.asc \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --batch --verify /tini.asc /sbin/tini \
 && rm -rf "$GNUPGHOME" /tini.asc \
 && chmod +x /sbin/tini

ENTRYPOINT ["/sbin/tini", "--"]


# Clean up for docker squash
# See https://github.com/goldmann/docker-squash
RUN rm -rf \
    /root/.cache \
    /root/.npm \
    /root/.pip \
    /usr/local/share/doc \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/vim/vim74/doc \
    /usr/share/vim/vim74/lang \
    /usr/share/vim/vim74/spell/en* \
    /usr/share/vim/vim74/tutor \
    /var/lib/apt/lists/* \
    /tmp/*
