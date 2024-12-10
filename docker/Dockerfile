FROM ubuntu:20.04
ARG S6_OVERLAY_VERSION=3.2.0.2

RUN apt-get update && apt-get install -y nginx xz-utils openssh-server \
    wget cron vim nano python sudo

# Install s6
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Create and configure blueteam user
RUN useradd -m -s /bin/bash blueteam && \
    echo "blueteam:blueteam" | chpasswd && \
    mkdir -p /home/blueteam/.ssh && \
    chown blueteam:blueteam /home/blueteam/.ssh
RUN usermod -aG sudo blueteam

# Setup SSH
RUN mkdir /var/run/sshd
COPY ./config/ssh/sshd_config /etc/ssh/sshd_config

# Create the service for sshd
RUN mkdir -p /etc/services.d/sshd && \
    echo '#!/bin/sh\nexec /usr/sbin/sshd -D' > /etc/services.d/sshd/run && \
    chmod +x /etc/services.d/sshd/run



EXPOSE 22

ENTRYPOINT ["/init"]
