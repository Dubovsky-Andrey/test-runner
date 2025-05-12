#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

ls /usr/local/bin/
mkdir -p /run/dbus
dbus-daemon --system --fork

nordvpnd &
sleep 5

timeout 120s bash -c 'while [ ! -S /run/nordvpn/nordvpnd.sock ]; do sleep 2; echo "[INFO] Waiting for nordvpnd.sock ready"; done'
echo "[INFO] Nordvpnd socket ready