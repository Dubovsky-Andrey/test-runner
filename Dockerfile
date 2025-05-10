# ========== Dockerfile ==========

FROM ubuntu:22.04

LABEL maintainer="you@example.com"

# Не задаёт интерактивных вопросов при установке
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# 1. Предустановка tzdata и установка всех нужных пакетов
RUN echo "tzdata tzdata/Areas select Etc" | debconf-set-selections \
 && echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      tzdata \
      curl \
      unzip \
      iproute2 \
      iptables \
      libicu70 \
      libnl-3-200 \
      libnl-genl-3-200 \
      libxml2 \
      apt-transport-https \
      gnupg \
      dbus \
 && rm -rf /var/lib/apt/lists/*

# 2. Установка NordVPN CLI
RUN curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh \
      | sh -s -- -n \
 && rm -rf /var/lib/apt/lists/*

# 3. Добавляем только скрипт запуска
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 4. Точка входа — только для runtime-логики
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
