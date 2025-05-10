#!/usr/bin/env bash
echo "Hello from self-hosted runner on $(hostname)"
echo "GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "GITHUB_SHA:        $GITHUB_SHA"

# ========== entrypoint.sh ==========
set -euo pipefail

# 1. Старт D-Bus
mkdir -p /run/dbus
dbus-daemon --system --fork

# 2. Старт nordvpnd
nordvpnd &
sleep 5

# 3. Ждём UNIX-сокет nordvpnd
for i in $(seq 1 20); do
  [[ -S /run/nordvpn/nordvpnd.sock ]] && { echo "nordvpnd socket ready"; break; }
  echo "waiting for nordvpnd.sock"; sleep 2
done

# 4. Добавляем подсеть для WebUI (пример)
nordvpn whitelist add subnet 10.244.0.0/16

# 5. Авторизация и соединение
#    Передайте токен через переменную окружения NORD_TOKEN
nordvpn login --token "${NORD_TOKEN}"
nordvpn set killswitch on
nordvpn set autoconnect on
nordvpn connect

# 6. Ждём появления интерфейса nordlynx
for i in $(seq 1 30); do
  if ip link show nordlynx &>/dev/null; then
    echo "nordlynx is up"
    break
  fi
  echo "waiting for nordlynx"; sleep 2
done

# 7. Держим контейнер живым
exec tail -f /dev/null