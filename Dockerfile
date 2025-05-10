# ========== Dockerfile ==========
FROM ubuntu:22.04

LABEL maintainer="you@example.com"

# Enable non-interactive APT and set timezone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# 1. Preseed tzdata and install runtime dependencies + NordVPN via official script
RUN echo "tzdata tzdata/Areas select Etc" | debconf-set-selections \
 && echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections \
 && apt update \
 && apt upgrade \
 && apt install -y --no-install-recommends \
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
 && rm -rf /var/lib/apt/lists/* \
 

# 2. Copy the entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 3. Use the script as the container's entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
