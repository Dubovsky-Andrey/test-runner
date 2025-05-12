#!/bin/bash
set -eu
export DEBIAN_FRONTEND=noninteractive

ls /usr/local/bin/
mkdir -p /run/dbus
dbus-daemon --system --fork

nordvpnd &
sleep 5

for i in $(seq 1 20); do
  if [ -S /run/nordvpn/nordvpnd.sock ]; then
    echo "nordvpnd socket ready"
    break
  fi
  echo "waiting for nordvpnd.sock"
  sleep 2
done