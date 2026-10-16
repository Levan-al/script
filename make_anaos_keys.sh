#!/usr/bin/env bash
# Generate AnaOS platform keys — RUN ONLY ON AIR-GAPPED MACHINE (TASK_019).
# Does not commit or upload anything.
set -euo pipefail
OUT="${1:-$HOME/anaos-keys}"
SUBJECT='/C=GE/ST=Tbilisi/L=Tbilisi/O=AnaOS/OU=AnaOS/CN=AnaOS/emailAddress=security@anaos.org'
MAKE_KEY="${MAKE_KEY:-development/tools/make_key}"

if [[ ! -x "$MAKE_KEY" && ! -f "$MAKE_KEY" ]]; then
  echo "Set MAKE_KEY to AOSP development/tools/make_key path" >&2
  exit 1
fi

mkdir -p "$OUT"
cd "$OUT"
for name in platform media shared releasekey otakey; do
  if [[ -e "${name}.pk8" ]]; then
    echo "skip existing $name"
    continue
  fi
  echo "Generating $name ..."
  "$MAKE_KEY" "$name" "$SUBJECT"
done
echo "Public PEMs in $OUT — copy ONLY *.x509.pem to online systems."
echo "Keep *.pk8 offline encrypted. See docs/KEY_CEREMONY.md"
