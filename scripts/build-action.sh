#!/usr/bin/env bash
#
# build-action.sh — produce dist/index.js from src/index.js.
#
# The action has zero runtime dependencies (Node built-ins only), so "building"
# is a copy plus a set of assertions that catch the mistakes that actually
# happen: missing dist, stray require() of a non-builtin, or syntax errors.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

info() { printf '  %s\n' "$*"; }
fail() { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }

echo "Building LGPT action"

[ -f src/index.js ] || fail "src/index.js not found"

node --check src/index.js || fail "src/index.js has a syntax error"
info "syntax ok"

# Anything not prefixed node: would require an npm package, and we ship none.
if grep -nE "require\(['\"][^.]" src/index.js | grep -v "node:" ; then
    fail "src/index.js requires a non-builtin module. The action must stay dependency-free."
fi
info "zero external dependencies confirmed"

mkdir -p dist
cp src/index.js dist/index.js
chmod +x dist/index.js

node --check dist/index.js || fail "dist/index.js has a syntax error"
info "dist/index.js is valid"

[ "$(wc -c < dist/index.js)" -gt 1000 ] || fail "dist/index.js looks truncated"
info "$(wc -c < dist/index.js) bytes"

ok "Action built"