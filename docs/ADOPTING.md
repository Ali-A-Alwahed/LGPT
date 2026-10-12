# Adopting the LGPT License

Three ways to add the LGPT License v1.0 to a project, roughly in order of how
often you should reach for them.

| | Method | Best for |
|---|---|---|
| 1 | [Template repository](#method-1-the-template-repository) | Starting a brand-new project |
| 2 | [GitHub Action](#method-2-the-github-action) | Automating it in CI |
| 3 | [Installer script](#method-3-the-installer-script) | Adding it to an existing project by hand |

All three write the same two files and verify the same SHA-256 digest.

---

## Method 1: the template repository

The fastest path for a new project.

<div align="center">

## 🚀 <a href="https://github.com/Ali-A-Alwahed/LGPT-template/generate">Use this template</a>

</div>

**In the browser:** click the link above. GitHub opens the repo creation page
with everything pre-populated. Name your repo and click *Create repository from
template*.

**From the CLI:**

```bash
gh repo create my-project --template Ali-A-Alwahed/LGPT-template --public
```

You get a repository containing:

```
my-project/
├── LICENSE.txt      the LGPT License v1.0
├── NOTICE           attribution notice
├── AUTHORS          creator and contributor record
├── README.md        project readme, pre-wired with the badge
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── CHANGELOG.md
└── .gitignore
```

Then:

```bash
cd my-project
git remote remove origin
git add .
git commit -m "Initial commit"
```

---

## Method 2: the GitHub Action

Use this when you want the license enforced and applied automatically, for
example across an organisation's repositories.

```yaml
name: Ensure LGPT license
on:
  push:
    branches: [main]
  schedule:
    - cron: "0 3 * * 1"   # weekly re-check

jobs:
  license:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4

      - name: Add LGPT license
        id: lgpt
        uses: Ali-A-Alwahed/LGPT@v1
        with:
          verify-checksum: true

      - name: Commit changes
        if: steps.lgpt.outputs.action == 'installed' || steps.lgpt.outputs.action == 'upgraded'
        run: |
          git config user.name  "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git add LICENSE.txt NOTICE
          git commit -m "chore: add LGPT License v1.0"
          git push
```

### Pin to a commit SHA

For anything you actually depend on, pin to a SHA rather than a tag:

```yaml
- uses: Ali-A-Alwahed/LGPT@<full-commit-sha> # v1.0.0
```

This is what Dependabot and the GitHub security team recommend, and it means an
updated tag cannot change the code you run.

### Inputs

| Input | Default | Meaning |
|---|---|---|
| `license-file` | `LICENSE.txt` | Where to write the license text |
| `notice-file` | `NOTICE` | Notice file to create; empty to skip |
| `project-name` | repo name | Name used in the NOTICE file |
| `verify-checksum` | `true` | Verify the SHA-256 digest |
| `overwrite` | `false` | Replace a non-LGPL license file |
| `uninstall` | `false` | Remove the files instead of adding them |

### Outputs

| Output | Meaning |
|---|---|
| `action` | `installed`, `already-present`, `upgraded`, `uninstalled`, or `failed` |
| `license-path` | Absolute path of the file written |
| `checksum` | SHA-256 of the text that was written |

### Safety properties

The Action is written against **Node built-ins only** — there is no
`node_modules`, no bundled third-party code, and no supply-chain surface beyond
GitHub itself. `node_modules` is a well-documented attack vector against
actions, and this one does not have one.

It also:

- Verifies the SHA-256 digest by default and aborts on mismatch.
- Refuses to overwrite a non-LGPL license file unless `overwrite: true`.
- Refuses to write outside `GITHUB_WORKSPACE`, so a crafted input cannot escape
  into `/etc`.
- Leaves an existing `NOTICE` untouched rather than clobbering it.

### Building it

```bash
./scripts/build-action.sh
```

Copies `src/index.js` to `dist/index.js` and asserts the action stays
dependency-free and syntactically valid. There is no bundler because there is
nothing to bundle.

---

## Method 3: the installer script

For an existing project, run:

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh | bash
```

Or clone the repo and run it locally, which is better if you want to read it
first:

```bash
git clone https://github.com/Ali-A-Alwahed/LGPT.git
bash LGPT/scripts/install-lgpt.sh --dir ~/code/my-project
```

### Options

```
--dir <path>     Target directory. Default: current directory.
--name <name>    Project name recorded in NOTICE. Default: directory name.
--yes, -y        Do not prompt.
--verify         Verify the SHA-256 digest (default).
--no-verify      Skip verification. Not recommended.
--force          Overwrite a LICENSE that is not an LGPT license.
--uninstall      Remove the LGPT LICENSE and NOTICE.
--help, -h       Show help.
--version, -v    Print the license version.
```

### Non-interactive use

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh \
  | bash -s -- --dir ~/code/my-project --name my-project --yes
```

### What it will not do

- **It will not overwrite another project's license.** If `LICENSE.txt` exists
  and is not an LGPT license, it stops and tells you. `--force` overrides this
  deliberately. This is why `curl | bash -- --yes` cannot quietly destroy an
  MIT license.
- **It will not write if the checksum fails.** Not even with `--force`.
- **It will not touch an existing `NOTICE`.** It warns and leaves it for you to
  merge, because `NOTICE` files accumulate other attributions.

### Removing it

```bash
bash install-lgpt.sh --dir ~/code/my-project --uninstall
```

Only removes files that actually look like LGPT files. This does not retroactively
release anything you already distributed — attribution obligations attached to
copies already in circulation stay attached.

### Verifying the script itself

If you are cautious about piping a remote script into a shell, which is a fair
default:

```bash
curl -fsSLO https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh
less install-lgpt.sh          # read it
bash install-lgpt.sh --dir .  # then run it
```

Or pin and verify:

```bash
EXPECTED=$(curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/SHA256SUMS | grep install-lgpt.sh)
curl -fsSL -o i.sh https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh
echo "$EXPECTED" | sed 's|scripts/||' | sha256sum -c -
```

---

## After adopting

### 1. Add the badge

```markdown
[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](https://github.com/Ali-A-Alwahed/LGPT)
```

### 2. Check your package metadata

Set the license field so tooling can see it:

| Ecosystem | Value |
|---|---|
| `package.json` | `"license": "SEE LICENSE IN LICENSE.txt"` |
| `pyproject.toml` | `license = { file = "LICENSE.txt" }` |
| `Cargo.toml` | `license-file = "LICENSE.txt"` |
| `go.mod` | *(none — ship `LICENSE.txt` alongside)* |
| `pom.xml` | `<license><name>LGPT-1.0</name>...` |
| `pubspec.yaml` | `license: "LGPT-1.0"` (may warn — Dart validates against SPDX) |

`LicenseRef-LGPT-1.0` is the correct SPDX expression where custom values are
permitted. See [SPDX.md](../SPDX.md).

### 3. Source headers

Optional, per §28:

```c
/* SPDX-License-Identifier: LicenseRef-LGPT-1.0
 * Copyright (c) 2026 Your Name
 * Licensed under the LGPT License v1.0
 */
```

### 4. Tell people

LGPT gets adopted when people know it exists. If you use it, link back to
<https://github.com/Ali-A-Alwahed/LGPT> and consider starring it. That is
genuinely the single biggest factor in whether anyone finds it.