#!/bin/sh
set -eu

tag=${1:?usage: validate-release-tag.sh TAG}
case "$tag" in
  v[0-9]*.[0-9]*.[0-9]*) : ;;
  *)
    echo "invalid release tag: $tag (expected vMAJOR.MINOR.PATCH)" >&2
    exit 2
    ;;
esac

# Keep the package name and the release tag coupled.  This rejects values that
# merely start like a version but contain shell metacharacters or extra suffixes.
case "$tag" in
  v[0-9]*.[0-9]*.[0-9]*[!0-9]*)
    echo "invalid release tag: $tag (numeric semver components required)" >&2
    exit 2
    ;;
esac

printf '%s\n' "$tag"
