#!/bin/sh
set -eu

version=${1:?usage: install.sh VERSION}
version=${version#v}

case "$version" in
  ''|*[!0-9.]*|.*|*.|*..*)
    echo "version must be a numeric X.Y.Z release (for example, 0.1.1)" >&2
    exit 2
    ;;
esac
version_parts=$(printf '%s\n' "$version" | awk -F. 'NF == 3 && $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ && $3 ~ /^[0-9]+$/ { print "ok" }')
if [ "$version_parts" != ok ]; then
  echo "version must be a numeric X.Y.Z release (for example, 0.1.1)" >&2
  exit 2
fi

case "$(uname -s)" in
  Linux) os=linux ;;
  Darwin) os=darwin ;;
  *) echo "unsupported operating system: $(uname -s)" >&2; exit 2 ;;
esac

case "$(uname -m)" in
  x86_64|amd64) arch=amd64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 2 ;;
esac

asset="gha-concurrency-cycle_v${version}_${os}_${arch}.tar.gz"
install_root=${RUNNER_TEMP:-${TMPDIR:-/tmp}}/gha-concurrency-cycle/${version}/${os}_${arch}
archive=$install_root/$asset
checksums=$install_root/SHA256SUMS
mkdir -p "$install_root"

if [ -n "${GHA_CONCURRENCY_CYCLE_ASSET_DIR:-}" ]; then
  cp "$GHA_CONCURRENCY_CYCLE_ASSET_DIR/$asset" "$archive"
  cp "$GHA_CONCURRENCY_CYCLE_ASSET_DIR/SHA256SUMS" "$checksums"
else
  base_url="https://github.com/kentomk/gha-concurrency-cycle/releases/download/v${version}"
  curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
    "$base_url/$asset" --output "$archive"
  curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
    "$base_url/SHA256SUMS" --output "$checksums"
fi

matching_entries=$(awk -v name="$asset" '$2 == name { count += 1 } END { print count + 0 }' "$checksums")
if [ "$matching_entries" -ne 1 ]; then
  echo "checksum entry must contain exactly one row for $asset" >&2
  exit 2
fi
expected=$(awk -v name="$asset" '$2 == name { print $1; exit }' "$checksums")

if command -v sha256sum >/dev/null 2>&1; then
  actual=$(sha256sum "$archive" | awk '{ print $1 }')
else
  actual=$(shasum -a 256 "$archive" | awk '{ print $1 }')
fi
if [ "$actual" != "$expected" ]; then
  echo "checksum mismatch for $asset" >&2
  exit 2
fi

tar -xzf "$archive" -C "$install_root"
chmod +x "$install_root/gha-concurrency-cycle"
printf '%s\n' "$install_root/gha-concurrency-cycle"
