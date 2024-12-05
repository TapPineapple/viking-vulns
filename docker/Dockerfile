# Base Image
FROM ubuntu:20.04

# Metadata
LABEL maintainer="adinandrewjura@gmail.com"
LABEL version="1.0"
LABEL description="Vulnerable Linux server for hardening competition"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and vulnerable software
RUN apt-get update && apt-get install -y \
    sudo \
    apache2=2.4.49-1ubuntu1 \
    openssh-server \
    mysql-server \
    php libapache2-mod-php \
    curl wget vim \
    --no-install-recommends

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo "root:toor" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
