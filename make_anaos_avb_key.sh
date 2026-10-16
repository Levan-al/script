#!/usr/bin/env bash
# Generate 4096-bit AVB key — AIR-GAPPED ONLY (TASK_020).
set -euo pipefail
OUT="${1:-$HOME/anaos-keys/avb}"
mkdir -p "$OUT"
openssl genrsa 4096 | openssl pkcs8 -topk8 -nocrypt -out "$OUT/avb.pem"
# Extract public key for device embedding with avbtool from AOSP tree:
# avbtool extract_public_key --key "$OUT/avb.pem" --output "$OUT/avb_pkmd.bin"
echo "Created $OUT/avb.pem — keep offline. Extract public with avbtool on the ceremony machine."
