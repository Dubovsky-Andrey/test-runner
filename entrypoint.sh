#!/bin/bash
set -e
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

#nordvpn set killswitch on
#nordvpn set autoconnect on
#nordvpn whitelist add subnet 10.244.0.0/16

#sysctl -w net.ipv4.ip_forward=1
#iptables -t nat -A POSTROUTING -o nordlynx -j MASQUERADE

