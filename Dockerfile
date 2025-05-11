# ========== Dockerfile ==========
FROM ubuntu:22.04

LABEL maintainer="nord-vpn"

# 1. Enable non-interactive APT and set timezone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# 2. Preseed tzdata and install dependencies
RUN echo "tzdata tzdata/Areas select Etc" | debconf-set-selections \
 && echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
      curl \
      dbus \
      tzdata \
      unzip \
      iproute2 \
      iptables \
      libicu70 \
      libnl-3-200 \
      libnl-genl-3-200 \
      libxml2 \
      apt-transport-https \
      gnupg \
 && rm -rf /var/lib/apt/lists/* \
 && curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh \
      | sh -s -- -n

# 3. Copy the entrypoint script
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

# 4. Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
