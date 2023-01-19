FROM alpine:3.14.8

# Install the requirements for PS
RUN apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

# Download the powershell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.3.1/powershell-7.3.1-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz

# Create the target folder where powershell will be placed
RUN mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Delete the powershell .tar.gz
RUN rm /tmp/powershell.tar.gz

# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Install Cron
RUN apk add --no-cache dcron

# Copy and install PS Modules
COPY src/installmodules.ps1 /scripts/installmodules.ps1
RUN pwsh /scripts/installmodules.ps1

# Copy and modify the entry script
COPY src/entry.sh /scripts/entry.sh
RUN chmod 755 /scripts/entry.sh

# Make /app mountable
VOLUME /app

# Create empty txt for container to stay alive
RUN touch /var/log/cron.log

# Execute entry.sh
CMD ["/scripts/entry.sh"]