#!/usr/bin/env bash
# ========== entrypoint.sh ==========
set -euo pipefail

# If in CI, skip VPN steps
if [ "${CI:-false}" = "true" ]; then
  echo "[Info] CI mode → skipping runtime"
  exit 0
fi

# keep container alive
exec tail -f /dev/null
