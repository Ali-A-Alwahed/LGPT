#!/usr/bin/env bash
#
# ci-check.sh — everything CI runs. Runs locally in a few seconds.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

ok()   { printf '\033[32m  PASS\033[0m %s\n' "$*"; PASS=$((PASS + 1)); }
no()   { printf '\033[31m  FAIL\033[0m %s\n' "$*"; FAIL=$((FAIL + 1)); }
head_() { printf '\n\033[1m%s\033[0m\n' "$*"; }

head_ "Structure"
for f in LICENSE.txt LICENSE-MIT.txt README.md NOTICE AUTHORS CHANGELOG.md \
         CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md SPDX.md SHA256SUMS \
         action.yml src/index.js dist/index.js scripts/install-lgpt.sh; do
    [ -f "$f" ] && ok "$f exists" || no "$f is missing"
done

head_ "Installer script"
if bash -n scripts/install-lgpt.sh 2>/dev/null; then
    ok "syntax valid"
else
    no "syntax error"
fi
[ -x scripts/install-lgpt.sh ] && ok "executable bit set" || no "not executable"

head_ "Action"
if node --check src/index.js 2>/dev/null; then ok "src/index.js syntax valid"; else no "src/index.js syntax error"; fi
if node --check dist/index.js 2>/dev/null; then ok "dist/index.js syntax valid"; else no "dist/index.js syntax error"; fi
if cmp -s src/index.js dist/index.js; then
    ok "dist/index.js matches src/index.js"
else
    no "dist is stale — run ./scripts/build-action.sh"
fi
if grep -E "require\(['\"][^.]" src/index.js 2>/dev/null | grep -qv "node:"; then
    no "src/index.js requires a non-builtin module"
else
    ok "zero external dependencies"
fi
[ -f package.json ] && no "a package.json exists; the action is meant to be dependency-free" || ok "no package.json (dependency-free)"
[ -d node_modules ] && no "node_modules/ is committed" || ok "no node_modules/"

head_ "Checksum consistency"
EXPECTED="$(awk '/LICENSE\.txt$/ {print $1; exit}' SHA256SUMS 2>/dev/null || true)"
ACTUAL="$(sha256sum LICENSE.txt | awk '{print $1}')"
SCRIPT_PIN="$(grep -oP '(?<=^LGPT_SHA256=")[0-9a-f]{64}' scripts/install-lgpt.sh || true)"
ACTION_PIN="$(grep -A1 'CANONICAL_SHA256 =' src/index.js | grep -oP "[0-9a-f]{64}" | head -n1 || true)"

[ -n "$EXPECTED" ] && ok "SHA256SUMS has a LICENSE.txt entry" || no "SHA256SUMS is missing a LICENSE.txt entry"
[ "$EXPECTED" = "$ACTUAL" ] && ok "SHA256SUMS matches LICENSE.txt" || no "SHA256SUMS is stale: $EXPECTED != $ACTUAL"
[ "$SCRIPT_PIN" = "$ACTUAL" ] && ok "installer SHA-256 pin is current" || no "install-lgpt.sh pin is stale: $SCRIPT_PIN != $ACTUAL"
[ "$ACTION_PIN" = "$ACTUAL" ] && ok "action SHA-256 pin is current" || no "index.js pin is stale: $ACTION_PIN != $ACTUAL"

head_ "Integrity manifest"
while read -r digest file; do
    [ -z "${digest:-}" ] && continue
    case "$digest" in \#*) continue ;; esac
    [ -f "$file" ] || { no "$file listed in SHA256SUMS but missing"; continue; }
    got="$(sha256sum "$file" | awk '{print $1}')"
    [ "$got" = "$digest" ] && ok "$file digest matches" || no "$file digest mismatch"
done < SHA256SUMS

head_ "Canonical text is not corrupted"
if grep -q "LGPT License v1.0" LICENSE.txt; then ok "LICENSE.txt has the expected title"; else no "LICENSE.txt title missing"; fi
SECTIONS="$(grep -c '^## [0-9]\+\.' LICENSE.txt || true)"
if [ "$SECTIONS" -eq 31 ]; then ok "31 numbered sections present"; else no "expected 31 sections, found $SECTIONS"; fi

head_ "Documentation links"
for link in docs/FAQ.md docs/ADOPTING.md docs/COMPARISON.md LICENSE.txt LICENSE-MIT.txt; do
    if grep -qE "\]\((\./)?${link//./\\.}\)" README.md; then ok "README links $link"; else no "README does not link $link"; fi
done

head_ "No dead references"
# Scoped to documentation: this check must not match its own source text.
if git grep -nI -e "Ali-A-Alwahed/LGPT-template" -- '*.md' >/dev/null 2>&1; then
    no "a reference to the removed LGPT-template repo is still present in the docs"
    git grep -nI -e "Ali-A-Alwahed/LGPT-template" -- '*.md' | sed 's/^/      /'
else
    ok "no documentation references the removed LGPT-template repo"
fi

head_ "Relative links resolve"
while read -r target; do
    [ -z "$target" ] && continue
    if [ -e "$target" ]; then
        ok "README link target exists: $target"
    else
        no "README link target is missing: $target"
    fi
done < <(grep -oE '\]\((\./)?(docs/)?[A-Za-z0-9_.-]+\.md\)' README.md 2>/dev/null \
    | sed -E 's/^\]\(\.?\/?//; s/\)$//' | sort -u)

head_ "Scaffold generator"
if bash -n scripts/generate-template.sh 2>/dev/null; then
    ok "generate-template.sh syntax valid"
else
    no "generate-template.sh syntax error"
fi

head_ "No leaked credentials"
if git grep -nIE "(gho_|ghp_|github_pat_)[A-Za-z0-9_]{16,}" -- . >/dev/null 2>&1; then
    no "a GitHub token appears to be committed in the working tree"
else
    ok "no GitHub tokens in tracked files"
fi

head_ "Summary"
printf '  %d passed, %d failed\n\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1