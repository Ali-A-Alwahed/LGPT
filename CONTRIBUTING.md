# Contributing to the LGPT License

Thank you for considering contributing. LGPT is better because people with
actual experience using it push back on it.

---

## What is useful

**Most useful, in order:**

1. **Real-world adoption reports.** You used it, here's what broke, here's what
   was ambiguous. This is worth more than a dozen editorial tweaks.
2. **Ambiguities in the text.** If a clause could be read two ways, that is a
   defect. Open an issue with the section number and both readings.
3. **Translations.** Legally these need care — see below.
4. **Tooling.** Package metadata, editor support, registry integrations.
5. **Documentation and examples.**
6. **Editorial improvements.** Typos, broken links, clarity.

---

## Editing the license text

`LICENSE.txt` is the canonical document. Treat changes to it as high-stakes.

### The rules

1. **Open an issue before you open a PR.** Discussing a substantive change
   first saves everyone the work of a rejected patch. Editorial fixes
   (typos, formatting) can skip straight to a PR.
2. **Any change to the terms bumps the version.** A wording fix does not; a
   changed obligation does. Version bumps go `1.0` → `1.1` → `2.0`.
3. **Section numbers are load-bearing.** §19 is referenced from the FAQ, the
   comparison doc, and the README. Do not renumber without updating all of
   them.
4. **Never weaken an obligation for existing recipients.** Version 1.0 grants
   cannot be retroactively withdrawn. Improvements are prospective only.
5. **One change per PR.** A terminology fix and a new clause are two PRs.

### What will be rejected

- Changes that reduce the freedoms §3 grants.
- Changes that make the license less readable without making it more precise.
- "Improvements" that make it look more like another license.
- Cosmetic rewrites of the whole document.

### What needs extra scrutiny

- Anything touching §12 (privacy), §15 (patents), or §17–18 (trademarks).
- Anything affecting enforceability.
- Translations.

---

## Translations

A translated license is legally delicate. A translation that diverges from the
English original can create two different licenses under one name.

If you contribute one:

- Put it in `translations/<ISO-639-1>/LICENSE.txt`.
- Include a header stating the English original is authoritative.
- Keep the section numbering identical.
- Do not translate legal terms of art into approximate equivalents — leave
  "Derivative Work", "Redistribute", and similar in English with a gloss.
- Add a note in the README of that directory explaining its status.

Translations are provided for convenience and do not modify the license.

---

## Code contributions

The tooling here is deliberately dependency-free. Please keep it that way.

### Invariants CI enforces

- `scripts/install-lgpt.sh` — POSIX-ish bash, no non-standard tools, no network
  calls except to the canonical license URL, checksum enforced.
- `src/index.js` — **Node built-ins only**. No `require()` of anything outside
  `node:`. There is no `package.json` and no `node_modules`, by design.
- `dist/index.js` — must be byte-identical to `src/index.js`. If you edit one,
  run `./scripts/build-action.sh`.

```bash
./scripts/build-action.sh     # rebuild dist
./scripts/ci-check.sh         # run everything CI runs
```

### Before you push

```bash
bash -n scripts/install-lgpt.sh    # syntax check the installer
./scripts/build-action.sh         # rebuild dist, assert zero deps
```

If you change the license text, also update:

- the pinned `LGPT_SHA256` in `scripts/install-lgpt.sh`
- the `CANONICAL_SHA256` constant in `src/index.js`
- `SHA256SUMS`

```bash
sha256sum LICENSE.txt
./scripts/build-action.sh
./scripts/refresh-checksums.sh
```

CI fails if these drift apart. That is intentional — a silent mismatch means
nobody can install the license.

---

## Commit messages

Use conventional prefixes:

```
feat: add Python packaging metadata example
fix: refuse to overwrite a non-LGPL LICENSE with --yes
docs: clarify the patent termination clause
chore: refresh SHA256SUMS after 1.0.1
```

---

## Code of Conduct

Participation is governed by [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

---

## Reporting a security issue

See [SECURITY.md](SECURITY.md). Security issues in the installer or the Action
are handled through private disclosure, not public issues.

---

## Licensing of contributions

By opening a pull request you agree that your contribution is licensed:

- **CC BY 4.0**, if it modifies `LICENSE.txt` or another documentation file, so
  the license text can be freely copied and shared.
- **MIT**, if it modifies code, scripts, workflows, or configuration.

See [`LICENSE-MIT.txt`](LICENSE-MIT.txt) and [`LICENSE.txt`](LICENSE.txt).

You keep copyright in your work. You are not required to sign a CLA, assign
rights, or open-source anything beyond the contribution itself.

---

## Review

Changes to `LICENSE.txt` are reviewed by the license author. Changes to
tooling are reviewed by anyone who cares to. Expect discussion, not silence.
Disagreement is normal and welcome — a license that cannot survive scrutiny is
not worth much.