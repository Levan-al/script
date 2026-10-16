# script

AnaOS build and release helper scripts (signing wrappers, factory/OTA helpers, CI glue).

| Script | Task | Notes |
| --- | --- | --- |
| `make_anaos_keys.sh` | 019 / 021 | platform, media, shared, releasekey, otakey — air-gapped |
| `make_anaos_avb_key.sh` | 020 | 4096-bit AVB — air-gapped |
| `make_anaos_app_keys.sh` | 022 | first-party app keys — air-gapped |
| `sign_anaos_release.sh` | 025 | sign target-files → images + OTA |

Private keys never live in this repository. Ceremony: `docs/KEY_CEREMONY.md`.
