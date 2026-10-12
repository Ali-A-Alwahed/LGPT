#!/usr/bin/env bash
#
# generate-template.sh — scaffold a new project licensed under the LGPT License v1.0.
#
# Works from a clone:
#   bash scripts/generate-template.sh my-project
#
# Works straight from the network:
#   curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/generate-template.sh \
#     | bash -s -- my-project
#
set -euo pipefail

LGPT_VERSION="1.0"
LGPT_SHA256="89d54b0cf5852c9212d80729c802a5371b41e8ce1499a32f8133382519c62b37"
LGPT_RAW_URL="https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/LICENSE.txt"
LGPT_REPO_URL="https://github.com/Ali-A-Alwahed/LGPT"
COPYRIGHT_HOLDER="Ali A Alwahed"
PROFILE_URL="https://github.com/Ali-A-Alwahed"
ORG="Sonzaistudios"
WEBSITE="https://sonzaistudios.org"

# Progress messages go to stderr on purpose: obtain_license() is called inside a
# command substitution, so anything on stdout would end up inside the license text.
info()    { printf '%s\n' ":: $*" >&2; }
ok()      { printf '\033[32m%s\033[0m %s\n' "✓" "$*" >&2; }
warn()    { printf '\033[31m%s\033[0m %s\n' "!" "$*" >&2; }
die()     { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
usage() {
    cat <<'HELP_EOF'
generate-template.sh — scaffold a new project under the LGPT License v1.0.

USAGE
    generate-template.sh <directory> [more-directories...]

    Creates <directory> containing LICENSE.txt, NOTICE, AUTHORS, README.md,
    CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md, CHANGELOG.md,
    .editorconfig, .gitignore, and a CI workflow.

    An existing directory must be empty, or contain only dotfiles.

EXAMPLES
    # From a clone
    bash scripts/generate-template.sh my-project

    # Straight from the network
    curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/generate-template.sh \
      | bash -s -- my-project

    # Several at once
    generate-template.sh api-gateway worker web-app
HELP_EOF
}

case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
    -v|--version)
        printf 'LGPT License v%s scaffold generator\n' "$LGPT_VERSION"
        exit 0
        ;;
esac

[ $# -ge 1 ] || { usage >&2; die "Expected at least one output directory."; }

# --- Obtain the canonical license text --------------------------------------
# Preferred source is a sibling checkout. When piped from the network there is
# no sibling file, so fall back to a checksum-verified download.
SELF_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
    SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
fi

TMP_LICENSE=""
cleanup() {
    if [ -n "$TMP_LICENSE" ]; then rm -f "$TMP_LICENSE"; fi
    return 0
}
trap cleanup EXIT

obtain_license() {
    if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/../LICENSE.txt" ]; then
        cat "$SELF_DIR/../LICENSE.txt"
        return 0
    fi

    info "Fetching the canonical license text..."
    TMP_LICENSE="$(mktemp "${TMPDIR:-/tmp}/lgpt-license.XXXXXX")"

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL --retry 3 --retry-delay 2 --proto '=https' --tlsv1.2 \
            -o "$TMP_LICENSE" "$LGPT_RAW_URL" \
            || die "Download failed. Fetch ${LGPT_RAW_URL} manually."
    elif command -v wget >/dev/null 2>&1; then
        wget -q --https-only --tries=3 -O "$TMP_LICENSE" "$LGPT_RAW_URL" \
            || die "Download failed. Fetch ${LGPT_RAW_URL} manually."
    else
        die "Neither curl nor wget found, and no sibling LICENSE.txt is available."
    fi

    if command -v sha256sum >/dev/null 2>&1; then
        actual="$(sha256sum "$TMP_LICENSE" | awk '{print $1}')"
    elif command -v shasum >/dev/null 2>&1; then
        actual="$(shasum -a 256 "$TMP_LICENSE" | awk '{print $1}')"
    else
        warn "No SHA-256 tool found. Skipping verification."
        cat "$TMP_LICENSE"
        return 0
    fi

    if [ "$actual" != "$LGPT_SHA256" ]; then
        die "License checksum mismatch.
     expected: $LGPT_SHA256
     actual:   $actual
     Nothing was written."
    fi
    ok "License checksum verified."
    cat "$TMP_LICENSE"
}

# Write everything once to a temp file, then fan out per target directory.
LICENSE_TEXT="$(obtain_license)"
[ -n "$LICENSE_TEXT" ] || die "Could not obtain the license text."

echo "$LICENSE_TEXT" | grep -q "LGPT License v" \
    || die "Obtained text does not look like an LGPT license. Aborting."

render_into() {
    dest="$1"
    mkdir -p "$dest/.github/workflows" || die "Could not create $dest"

    printf '%s\n' "$LICENSE_TEXT" > "$dest/LICENSE.txt"

    cat > "$dest/NOTICE" <<EOF
This project is licensed under the LGPT License v${LGPT_VERSION}.

------------------------------------------------------------------------

Developer:
${COPYRIGHT_HOLDER}

GitHub Profile:
${PROFILE_URL}

Organization:
${ORG}

Website:
${WEBSITE}

License:
LGPT License v${LGPT_VERSION}

GitHub Link:
${LGPT_REPO_URL}

------------------------------------------------------------------------

Special Thanks To:
${COPYRIGHT_HOLDER} for creating the LGPT License and establishing the licensing
framework used by this software.
EOF

    cat > "$dest/AUTHORS" <<'EOF'
# Authors

## License

This project is licensed under the [LGPT License v1.0](LICENSE.txt).

## Authors

- _Your name here_ — <your-email@example.com>

## Contributors

Thanks to everyone who has contributed. Add yourself in a pull request.
EOF

    cat > "$dest/README.md" <<'EOF'
<div align="center">

# Project Name

[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](LICENSE.txt)

One-line description of what this does.

</div>

---

## About

Explain what this project is, what problem it solves, and who it is for.

## Features

- Feature one
- Feature two

## Installation

```bash
# your install command here
```

## Usage

```bash
# example usage
```

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Licensed under the **LGPT License v1.0**. See [LICENSE.txt](LICENSE.txt) for the
full text and [NOTICE](NOTICE) for attribution requirements.

[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](https://github.com/Ali-A-Alwahed/LGPT)

LGPT lets you use, modify, and sell this software — including in closed-source
and commercial products — with no royalty. The one requirement is that you keep
the attribution notice. See [the license](https://github.com/Ali-A-Alwahed/LGPT)
for details.
EOF

    cat > "$dest/CONTRIBUTING.md" <<'EOF'
# Contributing

Thanks for your interest. Contributions are welcome.

## Getting started

1. Fork and create a branch.
2. Make your change.
3. Run any checks and make sure they pass.
4. Open a pull request describing what and why.

## Commit messages

Use conventional prefixes:

```
feat: add --verbose flag
fix: handle empty input
docs: clarify installation steps
chore: bump dependencies
```

## Pull requests

- One focused change per PR.
- Explain the motivation, not just the diff.
- Update the README if behaviour changes.

## Code of Conduct

Participation is governed by [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

By contributing you agree that your contributions are licensed under the
[LGPT License v1.0](LICENSE.txt). You retain copyright in your work.
EOF

    cat > "$dest/CHANGELOG.md" <<'EOF'
# Changelog

All notable changes to this project are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- _Nothing yet._

## [0.1.0] — unreleased

### Added

- Initial release.
EOF

    cat > "$dest/.gitignore" <<'EOF'
# Secrets
.env
.env.*
!.env.example

# Logs
*.log
npm-debug.log*
yarn-error.log*

# Dependencies
node_modules/
vendor/
.venv/
__pycache__/
*.py[cod]

# Build output
build/
dist/
target/
*.class

# Editors
.DS_Store
.idea/
.vscode/
*.swp

# Coverage
coverage/
*.lcov
EOF

    cat > "$dest/.editorconfig" <<'EOF'
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
EOF

    # Housekeeping files are copied from the checkout when available, and
    # otherwise fetched, so the scaffold is complete either way.
    for f in CODE_OF_CONDUCT.md SECURITY.md; do
        if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/../$f" ]; then
            cp "$SELF_DIR/../$f" "$dest/$f"
        else
            if command -v curl >/dev/null 2>&1; then
                curl -fsSL --proto '=https' --tlsv1.2 \
                    -o "$dest/$f" "${LGPT_REPO_URL}/raw/refs/heads/main/${f}" || rm -f "$dest/$f"
            fi
        fi
    done

    # A CI workflow that verifies the license is intact and has a clearly
    # marked slot for the project's real checks.
    cat > "$dest/.github/workflows/ci.yml" <<EOF
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: ci-\${{ github.ref }}
  cancel-in-progress: true

jobs:
  verify:
    name: Verify the license is intact
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check LICENSE.txt is unmodified
        run: |
          expected="${LGPT_SHA256}"
          actual="\$(sha256sum LICENSE.txt | awk '{print \$1}')"
          if [ "\$expected" != "\$actual" ]; then
            echo "::error::LICENSE.txt has been modified."
            exit 1
          fi
          echo "LICENSE.txt intact"

  hello:
    name: Placeholder check
    runs-on: ubuntu-latest
    steps:
      - run: echo "Replace this job with your project's real checks."
EOF
}

for dest in "$@"; do
    if [ -e "$dest" ]; then
        if [ -d "$dest" ] && [ -n "$(ls -A "$dest" 2>/dev/null)" ]; then
            die "$dest already exists and is not empty. Nothing was written."
        fi
    fi
    render_into "$dest"
    ok "Generated $dest/"
done

printf '\n%s\n\n' "Your project is licensed under LGPT v${LGPT_VERSION}."
cat <<EOF
Next steps
  cd "$1"
  git init && git add . && git commit -m "Initial commit"

  Keep the attribution notice in NOTICE and credit ${COPYRIGHT_HOLDER}:
  ${LGPT_REPO_URL}

  Full guide: ${LGPT_REPO_URL}/blob/main/docs/ADOPTING.md
EOF