#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_root"

jq -e '
  .schemaVersion == 2
  and ((.action == "create" or .action == "update") or .action == "update")
  and .owner == "kentomk"
  and (.name | type == "string" and test("^[a-z0-9][a-z0-9-]{1,62}$"))
  and (.description | type == "string" and length >= 20 and length <= 160)
  and (.topics | type == "array" and length >= 1 and length <= 10 and index("kento-oss") != null and all(type == "string"))
  and .candidateId == "20260717T120911Z-5f11"
  and (.targetUsers | type == "string" and length >= 10 and length <= 500)
  and (.jobToBeDone | type == "string" and length >= 10 and length <= 1000)
  and (.distributionPath | type == "string" and length >= 10 and length <= 500)
  and (.successMetric | type == "string" and length >= 10 and length <= 500)
  and (.reviewAfterDays | type == "number" and floor == . and . >= 1 and . <= 30)
  and .opportunityScore == 78
  and (.demandEvidence | type == "array" and length >= 3 and
       all(type == "object" and (.url | type == "string" and startswith("https://")) and
           (.kind | type == "string" and test("^[a-z][a-z0-9-]{2,49}$")) and
           (.independenceKey | type == "string" and (gsub("^\\s+|\\s+$"; "") | length >= 3 and length <= 200))))
  and ((.demandEvidence | map(.independenceKey | gsub("^\\s+|\\s+$"; "") | ascii_downcase) | unique | length) >= 3)
  and ((.demandEvidence | map(.kind) | unique | length) >= 2)
  and (.alternatives | type == "array" and length >= 3 and
       all(type == "object" and (.name | type == "string" and length >= 2 and length <= 200) and
           (.url | type == "string" and startswith("https://")) and .tested == true and
           (.gap | type == "string" and length >= 10 and length <= 1000)))
  and ((.alternatives | map((.name | ascii_downcase) + "\n" + .url) | unique | length) >= 3)
  and .duplicateSearch.completed == true
  and (.duplicateSearch.summary | type == "string" and length >= 20)
  and (.differentiation | type == "string" and length >= 20)
  and .testCommand == "scripts/publisher-gate.sh"
  and .license == "Apache-2.0"
  and (.commitMessage | type == "string" and length >= 10 and length <= 120)
' publish-request.json >/dev/null

jq -e --slurpfile request publish-request.json '
  .schemaVersion == 1
  and .candidateId == $request[0].candidateId
  and (.createdBy | test("Matsuki Kento") and test("@kentomk") and test("AI|automated"; "i"))
' .kento-oss.json >/dev/null

grep -Eq '^## (Installation|Install|Getting Started)\b' README.md
grep -Eq '^## Quick[[:space:]]*start\b' README.md
grep -Fq 'Use this when a same-repository reusable workflow' README.md
grep -Fq 'Do not use it for job-level concurrency' README.md
grep -q 'Matsuki Kento' README.md
grep -q '@kentomk' README.md
grep -Eiq 'AI|automated' README.md
grep -Eq 'uses: actions/checkout@[0-9a-f]{40}([[:space:]]|$)' README.md
grep -Eq 'uses: kentomk/gha-concurrency-cycle@[0-9a-f]{40}([[:space:]]|$)' README.md
grep -Fq 'uses: kentomk/gha-concurrency-cycle@35418343ab70907e69e0ce0f2293dc2e80bbdede # v0.1.2' README.md
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@4179c989f28110a92aedb53cb58acecbdcec6fd1' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@7126695735b388399a765a9dde4398abd2f20e33' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@9fb3b678261795ce891bed8079e7ea8ed47c077e' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@f54127c33f01c86589faf5b953efc74e753fc0da' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@85c0903368206ca0b5564d347d2c43311bdd8011' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@908c006073f24ec5d1cdb7e4ffedf6bb7d21ad3f' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Fq 'uses: kentomk/gha-concurrency-cycle@47bfb04ca567e92261ff5ac273ada1ee02f011fb' README.md; then
  echo 'publisher contract: README still pins the superseded public Action revision' >&2
  exit 1
fi
if grep -Eq 'uses: (actions/checkout|kentomk/gha-concurrency-cycle)@(main|master|v[0-9])' README.md; then
  echo 'mutable copy-ready Action reference found in README' >&2
  exit 1
fi
checkout_line=$(grep -n -m1 'uses: actions/checkout@' README.md | cut -d: -f1)
preflight_line=$(grep -n -m1 'uses: kentomk/gha-concurrency-cycle@' README.md | cut -d: -f1)
if [ "$checkout_line" -ge "$preflight_line" ]; then
  echo 'copy-ready workflow must checkout the caller repository before preflight' >&2
  exit 1
fi

grep -Eq 'uses: actions/checkout@[0-9a-f]{40}([[:space:]]|$)' .github/workflows/ci.yml
grep -Eq 'uses: actions/setup-go@[0-9a-f]{40}([[:space:]]|$)' .github/workflows/ci.yml
if grep -Eq 'uses: actions/(checkout|setup-go)@v[0-9]' .github/workflows/ci.yml; then
  echo 'mutable GitHub Action reference found' >&2
  exit 1
fi
grep -Fq "go-version: '1.26.5'" action.yml
if grep -Fq 'go-version-file:' action.yml; then
  echo 'Action must use the reviewed exact Go patch' >&2
  exit 1
fi
grep -Fq "go-version: '1.26.5'" .github/workflows/ci.yml

test -x scripts/publisher-gate.sh
sh -n scripts/publisher-gate.sh
grep -Fq 'releases/tag/v0.1.2' README.md
grep -Fq 'matching_entries=$(awk -v name="$archive"' README.md
grep -Fq 'test "$matching_entries" -eq 1' README.md
grep -Fq 'awk -v name="$archive" '\''$2 == name { print; exit }'\'' SHA256SUMS | sha256sum --check --strict -' README.md
grep -Fq 'unsafe_member=$(tar -tzf "$archive" | awk' README.md
grep -Fq 'archive contains an unsafe member path' README.md
grep -Fq 'unsafe_member=$(tar -tzf "$archive" | awk' scripts/install.sh
grep -Fq 'shasum -a 256 --check -' README.md
grep -Fq 'SHA256SUMS' scripts/install.sh
! grep -Fq 'checksums.txt' scripts/install.sh
grep -Fq 'test "$("$installed" version)" = "v0.1.2"' tests/install-script.sh
grep -Fq 'The published' SECURITY.md
grep -Fq 'v0.1.2' SECURITY.md
if grep -Fq 'not published yet' SECURITY.md; then
  echo 'SECURITY.md still claims the public project is unpublished' >&2
  exit 1
fi
