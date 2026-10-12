#!/usr/bin/env bash
#
# generate-template.sh — build the LGPT-template starter repository.
#
# Run from anywhere; writes to a target directory you name. The template repo is
# generated from the canonical LICENSE.txt so the two can never drift.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${1:-}"

if [ -z "$DEST" ]; then
    printf 'usage: %s <output-directory>\n' "$0" >&2
    exit 2
fi

mkdir -p "$DEST/.github/workflows"
cp "$SRC/LICENSE.txt" "$DEST/LICENSE.txt"

# --- NOTICE ---------------------------------------------------------------
cat > "$DEST/NOTICE" <<'EOF'
This project is licensed under the LGPT License v1.0.

------------------------------------------------------------------------

Developer:
Ali A Alwahed

GitHub Profile:
https://github.com/Ali-A-Alwahed

Organization:
Sonzaistudios

Website:
https://sonzaistudios.org

License:
LGPT License v1.0

GitHub Link:
https://github.com/Ali-A-Alwahed/LGPT

------------------------------------------------------------------------

Special Thanks To:
Ali A Alwahed for creating the LGPT License and establishing the licensing
framework used by this software.
EOF

# --- AUTHORS ---------------------------------------------------------------
cat > "$DEST/AUTHORS" <<'EOF'
# Authors

## License

This project is licensed under the [LGPT License v1.0](LICENSE.txt).

## Authors

- _Your name here_ — <your-email@example.com>

## Contributors

Thanks to everyone who has contributed. Add yourself in a pull request.
EOF

# --- README ----------------------------------------------------------------
cat > "$DEST/README.md" <<'EOF'
<div align="center">

# Project Name

[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](LICENSE.txt)
[![GitHub Issues](https://img.shields.io/github/issues/owner/repo?style=flat-square)](../../issues)

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

Licensed under the **LGPT License v1.0**. See [LICENSE.txt](LICENSE.txt) for
the full text and [NOTICE](NOTICE) for attribution requirements.

[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](https://github.com/Ali-A-Alwahed/LGPT)

LGPT lets you use, modify, and sell this software — including in closed-source
and commercial products — with no royalty. The one requirement is that you keep
the attribution notice. See [the license](https://github.com/Ali-A-Alwahed/LGPT)
for the details.
EOF

# --- Housekeeping files ----------------------------------------------------
cp "$SRC/CODE_OF_CONDUCT.md" "$DEST/CODE_OF_CONDUCT.md"
cp "$SRC/SECURITY.md" "$DEST/SECURITY.md"

cat > "$DEST/CONTRIBUTING.md" <<'EOF'
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

cat > "$DEST/CHANGELOG.md" <<'EOF'
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

cat > "$DEST/.gitignore" <<'EOF'
# Secrets
.env
.env.*
!.env.example

# Logs
*.log
npm-debug.log*
yarn-debug.log*
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

cat > "$DEST/.editorconfig" <<'EOF'
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

# A CI workflow that works even with no build system configured yet.
cat > "$DEST/.github/workflows/ci.yml" <<'EOF'
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
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  verify:
    name: Verify the license is intact
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check LICENSE.txt is unmodified
        run: |
          expected="89d54b0cf5852c9212d80729c802a5371b41e8ce1499a32f8133382519c62b37"
          actual="$(sha256sum LICENSE.txt | awk '{print $1}')"
          if [ "$expected" != "$actual" ]; then
            echo "::error::LICENSE.txt has been modified."
            echo "  expected: $expected"
            echo "  actual:   $actual"
            exit 1
          fi
          echo "LICENSE.txt intact"

  hello:
    name: Placeholder check
    runs-on: ubuntu-latest
    steps:
      - run: echo "Replace this job with your project's real checks."
EOF

printf '\033[32m✓\033[0m Generated template in %s\n' "$DEST"