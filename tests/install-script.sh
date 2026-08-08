#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
smoke_root=$(mktemp -d)
cleanup() {
  chmod -R u+w "$smoke_root" 2>/dev/null || true
  rm -rf "$smoke_root"
}
trap cleanup EXIT HUP INT TERM

SOURCE_DATE_EPOCH=0 "$project_root/scripts/package-release.sh" v0.1.1 "$smoke_root/assets"
mkdir -p "$smoke_root/run"
installed=$(GHA_CONCURRENCY_CYCLE_ASSET_DIR="$smoke_root/assets" \
  RUNNER_TEMP="$smoke_root/run" \
  "$project_root/scripts/install.sh" v0.1.1)

test -x "$installed"
test "$("$installed" version)" = "v0.1.1"

for invalid_version in '../0.1.1' '0.1' '0.1.1.1' '0.1.x' '0..1'; do
  if GHA_CONCURRENCY_CYCLE_ASSET_DIR="$smoke_root/assets" \
    RUNNER_TEMP="$smoke_root/run" \
    "$project_root/scripts/install.sh" "$invalid_version" >/dev/null 2>&1; then
    echo "invalid version unexpectedly accepted: $invalid_version" >&2
    exit 1
  fi
done
