# Security Policy

## Supported versions

Only the current released version of the LGPT License receives updates.
Earlier versions are frozen — a superseded license version is never edited in
place, because doing so would change the terms for people who already
distributed under it.

| Version | Status |
|---|---|
| 1.0 | Current |

## Reporting a vulnerability

Security issues in the **installer script** or the **GitHub Action** should be
reported privately.

**Email:** security@sonzaistudios.org
**Subject:** `LGPT security report`

Please include:

- what the issue is,
- how to reproduce it,
- the impact — what an attacker gains,
- the version or commit SHA.

### What to expect

- Acknowledgement within **7 days**.
- Initial assessment within **14 days**.
- Fix released, or a reason it will not be, within **30 days**.

If a fix requires changing `LICENSE.txt`, a new version will be published
rather than modifying the existing one in place.

## What is in scope

The LGPT License is a legal document, not software. Most issues are therefore
with the tooling around it.

| Component | In scope |
|---|---|
| `scripts/install-lgpt.sh` | ✅ Command injection, unsafe file writes, checksum bypass, TOCTOU, unsafe temp files |
| `src/index.js`, `dist/index.js` | ✅ Path traversal, checksum bypass, unsafe output handling |
| `action.yml` | ✅ Unintended permissions, injection vectors |
| `LICENSE.txt` | ⚠️ Legal drafting issues that create unintended obligations or loss of rights |
| `docs/` | ❌ Typos |

### About `LICENSE.txt`

If you believe the license text contains a drafting error that would cause
real harm — a clause that could be read to strip rights someone should have, or
to impose an obligation the author did not intend — that is worth reporting
here. Open a **public issue** for anything that is merely unclear. Private
disclosure is for things that need coordinated timing.

## Out of scope

- Automated scanner findings with no working proof of concept.
- Missing SPDX registration (§ registration is a process, not a vulnerability).
- That the license is not on GitHub's license dropdown.
- Legal advice. We are not lawyers.
- Reports about third-party code you did not write.

## Security properties to rely on

These are intentional and enforced. If you find a way to break them, that is a
genuine vulnerability — please report it.

1. **The license text is checksum-verified.** Both the installer and the Action
   abort on a SHA-256 mismatch before writing anything. `--force` and
   `verify-checksum: false` exist as escape hatches and both emit warnings.
2. **The tooling has no dependencies.** No `node_modules`, no bundled
   third-party code. The supply-chain surface is GitHub Actions itself.
3. **The Action cannot write outside the workspace.** Inputs are resolved and
   checked against `GITHUB_WORKSPACE` before any write.
4. **Foreign license files are not clobbered.** Both the installer and the
   Action refuse to replace a `LICENSE` that is not an LGPT license unless
   explicitly forced.
5. **Existing `NOTICE` files are never overwritten.** They are left for manual
   merging because they carry unrelated attributions.
6. **Downloads are pinned to HTTPS**, with TLS 1.2 required where `curl` is
   used, and `--proto` restricted so a redirect cannot downgrade to `http` or
   `file`.

## Verifying a download yourself

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/SHA256SUMS \
  | grep -E 'LICENSE.txt|install-lgpt.sh'
```

```bash
sha256sum -c SHA256SUMS --ignore-missing
```