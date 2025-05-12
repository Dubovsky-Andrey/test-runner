#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

ls /usr/local/bin/
mkdir -p /run/dbus
dbus-daemon --system --fork

nordvpnd &
sleep 5

timeout 60s bash -c '
  until sockstat -n | grep -q "/run/nordvpn/nordvpnd.sock"; do
    sleep 2
    echo "[INFO] Waiting for nordvpnd.sock ready"
  done