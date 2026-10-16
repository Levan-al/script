#!/usr/bin/env bash
# Wrapper around AOSP sign_target_files_apks / ota_from_target_files (TASK_025).
# Expects KEYS_DIR with platform/media/shared/releasekey (and otakey if used).
set -euo pipefail
TARGET_FILES="${1:?target-files.zip}"
KEYS_DIR="${2:?path to keys dir}"
OUT_DIR="${3:-$PWD/signed-out}"
mkdir -p "$OUT_DIR"

SIGN_TARGET_FILES="${SIGN_TARGET_FILES:-build/make/tools/releasetools/sign_target_files_apks}"
IMG_FROM_TARGET="${IMG_FROM_TARGET:-build/make/tools/releasetools/img_from_target_files}"
OTA_FROM_TARGET="${OTA_FROM_TARGET:-build/make/tools/releasetools/ota_from_target_files}"

SIGNED="$OUT_DIR/signed-target-files.zip"
"$SIGN_TARGET_FILES" -o -d "$KEYS_DIR" "$TARGET_FILES" "$SIGNED"
"$IMG_FROM_TARGET" "$SIGNED" "$OUT_DIR/images.zip"
"$OTA_FROM_TARGET" -k "$KEYS_DIR/releasekey" "$SIGNED" "$OUT_DIR/ota.zip"
echo "Signed outputs in $OUT_DIR"
echo "Verify with avbtool before flashing (TASK_026)."
