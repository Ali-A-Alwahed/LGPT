#!/usr/bin/env bash
#
# refresh-checksums.sh — regenerate SHA256SUMS.
#
# Run this whenever LICENSE.txt, scripts/install-lgpt.sh, or src/index.js
# changes. It also re-pins the SHA-256 constants embedded in the installer and
# the Action, so the three never drift apart.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if command -v sha256sum >/dev/null 2>&1; then
    shasum() { sha256sum "$@"; }
fi

DIGEST="$(sha256sum LICENSE.txt | awk '{print $1}')"

printf '  re-pinning LICENSE.txt -> %s...\n' "${DIGEST:0:16}"

# Re-pin the installer's constant.
if grep -q '^LGPT_SHA256="[0-9a-f]\{64\}"' scripts/install-lgpt.sh; then
    sed -i.bak "s/^LGPT_SHA256=\"[0-9a-f]\{64\}\"/LGPT_SHA256=\"${DIGEST}\"/" \
        scripts/install-lgpt.sh
    rm -f scripts/install-lgpt.sh.bak
    printf '  updated scripts/install-lgpt.sh\n'
else
    printf '  WARNING: could not find LGPT_SHA256 in scripts/install-lgpt.sh\n' >&2
fi

# Re-pin the action's constant.
if grep -q "CANONICAL_SHA256 =" src/index.js; then
    sed -i.bak "s/\(CANONICAL_SHA256 =\s*'\)[0-9a-f]\{64\}/\1${DIGEST}/" src/index.js
    rm -f src/index.js.bak
    printf '  updated src/index.js\n'
else
    printf '  WARNING: could not find CANONICAL_SHA256 in src/index.js\n' >&2
fi

# Rebuild dist so it matches.
./scripts/build-action.sh >/dev/null

# Regenerate the manifest.
cat > SHA256SUMS <<EOF
# SHA-256 digests for files distributed with the LGPT License.
#
# Verify with:   sha256sum -c SHA256SUMS --ignore-missing
# Regenerate:    ./scripts/refresh-checksums.sh
#
# The LICENSE.txt digest is additionally hard-pinned inside
# scripts/install-lgpt.sh and src/index.js, which verify it on every run.

$(sha256sum LICENSE.txt)
$(sha256sum scripts/install-lgpt.sh)
$(sha256sum scripts/build-action.sh)
$(sha256sum scripts/ci-check.sh)
$(sha256sum scripts/refresh-checksums.sh)
$(sha256sum src/index.js)
$(sha256sum action.yml)
EOF

printf '  wrote SHA256SUMS (%s entries)\n' "$(grep -cE '^[0-9a-f]{64}' SHA256SUMS)"
printf '\n\033[32m✓\033[0m Checksums refreshed\n'