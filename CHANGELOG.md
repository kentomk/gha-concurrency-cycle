# Changelog

## Unreleased

- Refresh the copy-ready composite Action example and stale-pin regression for
  public main `35418343ab70907e69e0ce0f2293dc2e80bbdede` after the live CI check.
- Refresh the copy-ready composite Action example and stale-pin regression for public main `4179c989f28110a92aedb53cb58acecbdcec6fd1`.
- Refresh the copy-ready composite Action example and stale-pin regression for public main `47bfb04ca567e92261ff5ac273ada1ee02f011fb`.
- Refresh the copy-ready composite Action example and stale-pin regression for public main `908c006073f24ec5d1cdb7e4ffedf6bb7d21ad3f`.
- Align the copy-ready composite Action example and publisher regression with public main `85c0903368206ca0b5564d347d2c43311bdd8011`.
- Make the README's selected-archive checksum quickstart reject missing or duplicate manifest rows, matching the standalone installer and publisher contract.
- Align the copy-ready install, archive, and immutable Action examples with the
  published `v0.1.2` release and broker-verified public main revision.
- Reject checksum manifests that contain zero or multiple rows for the selected archive, and cover the fail-closed installer path with a regression smoke test.
- Align the copy-ready immutable Action example and publisher regression with public main `cdb7907e`.
- Enable cgo explicitly for the publisher's Zig-backed race test so a broker host's disabled default cannot mask release verification.
- Refresh the immutable Action example to the current successful public-main revision and reject the superseded pin in the publisher contract.
- Pin the installer smoke contract to the published CLI `version` output so release packaging and install verification cannot drift apart.
- Fix the standalone installer to fetch and verify the published `SHA256SUMS`
  asset instead of the non-existent `checksums.txt` name, with a release-install
  regression test; keep the archive filename's `v` prefix aligned with releases.
- Pin the copy-ready composite Action example to the current successful public main and reject the superseded revision in the publisher contract.
- Refresh the immutable Action example to public main `7126695` and reject the prior `de54781` pin in the publisher contract.
- Make manual and broker-triggered release repairs check out the requested tag before building assets.
- Pin the composite Action, CI, and release workflow to the publisher's reviewed Go `1.26.5` patch and add regressions against `go-version-file` and mutable patch selectors.
- Align the copy-ready install, Action pin, checksum example, and security policy with the published `v0.1.1` release.

- Add a copy-ready v0.1.0 release link and single-archive checksum verification
  for Linux and macOS binary installation.
- Fix the copy-ready GitHub Actions workflow to check out the caller repository
  before scanning, and include least-privilege `contents: read` permissions.

- Replace the copy-ready GitHub Action tag example with the verified immutable
  `v0.1.0` commit and enforce that contract in the publisher gate.
- Add an owner-repairable release workflow and make all four archives byte-reproducible with `SHA256SUMS`.
- Build the composite Action from its pinned source revision so it no longer requires unavailable release binary assets.
- Mirror the publisher's tracked-file, payload-size, credential-path, and credential-content limits in the local release gate.

All notable changes to this project will be documented here.

## Unreleased

- Add the initial `check` CLI.
- Detect `GCC001` for a same-repository caller/callee effective concurrency-group collision.
- Add conflict and caller-only safe fixtures with automated tests.
- Cover distinct literal groups, dynamic unknowns, malformed YAML, path escape, symbolic links, and graph cycles.
- Add deterministic fan-out text/JSON golden tests and bounded workflow count/file size checks.
- Add checksum-verified release archives and a composite GitHub Action with a local Linux smoke test.
- Add one CI release gate for race tests, dependency licenses, secret patterns, and a timed clean-checkout quickstart.
- Canonicalize an explicitly selected root and reject internal workflow-directory symbolic links before reading content.
- Add a broker-v2 publication contract, immutable CI Action pins, and a checksum-verified self-contained publisher gate.
