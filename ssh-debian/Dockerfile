# Use a base image with the desired OS (e.g., Ubuntu, Debian, etc.)
FROM debian:latest

# Install SSH server
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server sshpass \
    && apt-get install -y --no-install-recommends \
        telnet \
        iputils-ping \
        # netcat-openbsd \
        curl \
        wget \
        # socat \
    && rm -rf /var/lib/apt/lists/*

# # Create an SSH user
# RUN useradd -rm -d /home/sshuser -s /bin/bash -g root -G sudo -u 1000 sshuser

# # Set the SSH user's password (replace "password" with your desired password)
# RUN echo 'sshuser:password' | chpasswd

# # Allow SSH access
# RUN mkdir /var/run/sshd

# # Expose the SSH port
# EXPOSE 22

# # Start SSH server on container startup
# CMD ["/usr/sbin/sshd", "-D"]