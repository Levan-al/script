#!/usr/bin/env bash
# Generate AnaOS first-party app signing keys — AIR-GAPPED ONLY (TASK_022).
# Does not commit or upload anything. Private keys never leave the ceremony machine.
set -euo pipefail
OUT="${1:-$HOME/anaos-keys/apps}"
SUBJECT='/C=GE/ST=Tbilisi/L=Tbilisi/O=AnaOS/OU=AnaOS/CN=AnaOS/emailAddress=security@anaos.org'
MAKE_KEY="${MAKE_KEY:-development/tools/make_key}"

if [[ ! -x "$MAKE_KEY" && ! -f "$MAKE_KEY" ]]; then
  echo "Set MAKE_KEY to AOSP development/tools/make_key path" >&2
  exit 1
fi

# Dedicated keys for privileged / identity-sensitive apps.
# Other system packages may use platform or releasekey per product policy.
APPS=(
  updater
  auditor
  camera
  appstore
  pdfviewer
)

mkdir -p "$OUT"
cd "$OUT"
for name in "${APPS[@]}"; do
  if [[ -e "${name}.pk8" ]]; then
    echo "skip existing $name"
    continue
  fi
  echo "Generating app-$name ..."
  "$MAKE_KEY" "$name" "$SUBJECT"
done

cat > "$OUT/README.txt" <<'EOF'
AnaOS app signing keys (public side only is publishable).

Map to packages (see docs/BRANDING.md / docs/KEY_CEREMONY.md):
  updater.x509.pem   -> org.anaos.updater
  auditor.x509.pem   -> org.anaos.auditor
  camera.x509.pem    -> org.anaos.camera
  appstore.x509.pem  -> org.anaos.appstore
  pdfviewer.x509.pem -> org.anaos.pdfviewer

Copy ONLY *.x509.pem to online systems. Keep *.pk8 offline encrypted.
EOF

echo "Public PEMs in $OUT — copy ONLY *.x509.pem to online systems."
echo "Keep *.pk8 offline encrypted. See docs/KEY_CEREMONY.md"
