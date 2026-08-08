#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_root"

test -z "$(gofmt -l .)"
go test -race ./...
go vet ./...
tests/static-policy.sh
tests/publisher-contract.sh
tests/publisher-payload.sh
tests/action-smoke.sh
tests/release-package.sh
tests/release-workflow.sh
for tag in v0.0.1 v12.34.567; do
  test "$(scripts/validate-release-tag.sh "$tag")" = "$tag"
done
for tag in v1.2 v1.2.3-rc1 'v1.2.3;echo bad' v1.2.3.4; do
  if scripts/validate-release-tag.sh "$tag" >/dev/null 2>&1; then
    echo "invalid release tag accepted: $tag" >&2
    exit 1
  fi
done
tests/quickstart-clean.sh
