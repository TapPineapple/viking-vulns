FROM ubuntu:20.04
ARG S6_OVERLAY_VERSION=3.2.0.2

RUN apt-get update && apt-get install -y openssh-server \
    wget curl cron vim nano python sudo


#This section is for functionality and useability.

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

# Setup SSH (using vulnerable config)
RUN mkdir /var/run/sshd
COPY ./config/ssh/sshd_config /etc/ssh/sshd_config

# Create the service for sshd
RUN mkdir -p /etc/services.d/sshd && \
    echo '#!/bin/sh\nexec /usr/sbin/sshd -D -f /etc/ssh/sshd_config' > /etc/services.d/sshd/run && \
    chmod +x /etc/services.d/sshd/run

#Everything below will feature flaws that the players will have to correct.

COPY ./config/evil-home-dr/* /home/evil-viking/
RUN useradd -m -s /bin/bash evil-viking && \
    echo "evil-viking:vikings" | chpasswd && \
    mkdir -p /home/evil-viking/.ssh && \
    chown evil-viking:evil-viking /home/evil-viking/.ssh
RUN usermod -aG sudo evil-viking 

EXPOSE 22

ENTRYPOINT ["/init"]
