<div align="center">

# ⚖️ LGPT License v1.0

**Freedom · Flexibility · Attribution · Privacy**

[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](LICENSE.txt)
[![SPDX: LicenseRef-LGPT-1.0](https://img.shields.io/badge/SPDX-LicenseRef-LGPT--1.0-blue?style=flat-square)](SPDX.md)
[![GitHub Stars](https://img.shields.io/github/stars/Ali-A-Alwahed/LGPT?style=social)](https://github.com/Ali-A-Alwahed/LGPT)
[![GitHub Forks](https://img.shields.io/github/forks/Ali-A-Alwahed/LGPT?style=social)](https://github.com/Ali-A-Alwahed/LGPT/forks)
[![GitHub Issues](https://img.shields.io/github/issues/Ali-A-Alwahed/LGPT?style=flat-square)](https://github.com/Ali-A-Alwahed/LGPT/issues)

> *Use it anywhere — open or closed, commercial or personal. Keep your own code
> private. Just give credit.*

[**Read the license**](LICENSE.txt) · [**FAQ**](docs/FAQ.md) · [**Comparison**](docs/COMPARISON.md) · [**Adopt it**](docs/ADOPTING.md)

</div>

---

## 📑 Contents

- [What is LGPT?](#what-is-lgpt)
- [Why it exists](#why-it-exists)
- [How is it different?](#how-is-it-different)
- [Honest comparison](#honest-comparison)
- [Three ways to adopt it](#three-ways-to-adopt-it)
- [The three ways to use it](#the-three-ways-to-use-it)
- [Required attribution](#required-attribution)
- [Badge](#badge)
- [FAQ](#faq)
- [Contributing](#contributing)
- [Author](#author)

---

## What is LGPT?

**LGPT** is a permissive software license built around a simple bargain:

> You get every right a free software license can offer — use it, change it,
> sell it, keep it private, build commercial products on top of it.
> In exchange, you credit the original creator and never imply they endorse you.

It is deliberately close to MIT/BSD in spirit, with two things added that those
licenses leave unstated: an explicit **privacy and no-telemetry clause**, and an
explicit **non-endorsement clause**.

LGPT is *not* a copyleft license. It places no requirement on you to publish
your own source code.

---

## Why it exists

Most permissive licenses were written to maximize adoption by corporations, and
they are silent on matters that matter to individuals. LGPT was written to cover
those gaps without adding copyleft friction:

| Gap in mainstream permissive licenses | How LGPT addresses it |
|---|---|
| No language on telemetry or tracking | §12 grants no right to collect, sell, or transmit user data |
| No explicit non-endorsement clause | §17 and §18 block false endorsement and branding |
| No patent grant in MIT/ISC | §15 grants a royalty-free patent license with a termination clause |
| Nothing prevents "extra restrictions" being bolted on | §19 forbids removing rights already granted by this license |
| No protection against deceptive re-distribution of your code | §21 terminates only the violator's rights, not downstream recipients' |

---

## How is it different?

**Structurally, LGPT is an MIT/BSD-style permissive license.** If you strip out
§12, §17, §18 and §19, what remains is a familiar permissive license with a patent
grant.

That is a feature, not a weakness. A license you can read in five minutes and
that behaves the way your lawyer expects is worth more than novelty. LGPT's
distinction is not *more* freedom than MIT — MIT already grants that freedom.
The distinction is **explicit language** for privacy and non-endorsement that
other licenses leave to case law and custom clauses.

### Trade-offs you should know about

Choosing LGPT means:

- ❌ Your license will **not** be recognised by most package registries, IDEs, and automated licence scanners the way MIT or Apache-2.0 are. Expect to configure these manually.
- ❌ It is **not** on GitHub's built-in license dropdown. That list is fixed and curated; custom licenses cannot be added to it.
- ❌ Companies with automated open-source compliance tooling may flag it as **unapproved**, requiring legal sign-off.
- ❌ An **attribution requirement** means you cannot strip the notice, unlike The Unlicense (public domain dedication).
- ❌ It is a **non-OSI-approved** license, so "open source" in the strict OSI sense does not automatically apply.
- ✅ In exchange you get **explicit privacy protection**, an **explicit patent grant**, and **explicit anti-endorsement terms**.

> **Note on the name:** "LGPT" is unrelated to the GNU LGPL (Lesser General Public
> License). They are different licenses with confusingly similar acronyms. If you
> are looking for LGPL, you are in the wrong place.

---

## Honest comparison

Legend: ✅ yes · ⚠️ partial/conditional · ❌ no · — not applicable

| Capability | **LGPT** | MIT | Apache-2.0 | BSD-3 | ISC | MPL-2.0 | Unlicense |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Commercial use | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Modify & fork | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Sell products built on it | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Keep your own code private** | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ |
| **No share-alike obligation** | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ |
| **Attribution required** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Explicit patent grant** | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ❌ |
| **Explicit patent termination** | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Explicit non-endorsement clause** | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Privacy / no-telemetry clause** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Anti-tivoization (no added restrictions)** | ✅ | ❌ | ⚠️ | ❌ | ❌ | ⚠️ | ❌ |
| **Must mark changes as modified** | ⚠️ | ❌ | ❌ | ❌ | ❌ | ⚠️ | ❌ |
| **Tooling & registry support** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **On GitHub's license dropdown** | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| **OSI approved** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Notes on the table

These details matter more than the checkmarks:

- **Non-endorsement** — Apache-2.0 (§4(b)) and BSD-3 do contain explicit non-endorsement clauses; LGPL, MPL-2.0, MIT and ISC do not. MIT and ISC achieve the same *outcome* differently: they grant **no trademark rights at all**, so there is nothing to misuse. LGPT does what Apache-2.0 does — an explicit clause — rather than relying on silence.
- **Anti-tivoization** — §19 of LGPL and §10 of the GPL's "Installation Information" requirement are the strongest protections here, and they come with heavy obligations. LGPT §19 is much narrower: it only blocks removing *LGPT's own* granted rights, not linking duties. Apache-2.0 is marked ⚠️ because §4's patent/termination terms are conditions, not anti-restriction guarantees.
- **Unlicense** is a public-domain dedication, not a license. It forfeits attribution, patent claims, and all protections — which is the opposite trade from LGPT's.
- **Privacy clause** — no mainstream license addresses telemetry. That is genuinely a gap, and LGPT fills it.

---

## Three ways to adopt it

### 1. Scaffold a new project

The fastest path. Generates a complete project — license, notice, community
files, CI — already wired up with LGPT v1.0:

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/generate-template.sh \
  | bash -s -- -- my-project && cd my-project
```

That writes:

```
my-project/
├── LICENSE.txt         the LGPT License v1.0
├── NOTICE              attribution notice
├── AUTHORS             creator and contributor record
├── README.md           pre-wired with the badge
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── CHANGELOG.md
├── .editorconfig
├── .gitignore
└── .github/workflows/ci.yml
```

Then:

```bash
git init && git add . && git commit -m "Initial commit"
```

### 2. Add it to an existing project with one command

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh | bash
```

That script downloads the license, verifies its checksum, writes it to your project root, and creates a `NOTICE` file. It never overwrites an existing file without asking.

<pre><code>usage: install-lgpt.sh [--dir PATH] [--name NAME] [--yes] [--verify] [--uninstall]
</code></pre>

### 3. Use the GitHub Action

```yaml
name: Add LGPT license
on:
  push:
    branches: [main]

jobs:
  license:
    runs-on: ubuntu-latest
    steps:
      - uses: Ali-A-Alwahed/LGPT@v1
        with:
          verify-checksum: true
```

This is a zero-dependency action written against Node built-ins only — no `node_modules`, no supply-chain surface, and it can be pinned to a commit SHA.

See **[docs/ADOPTING.md](docs/ADOPTING.md)** for all three in detail.

---

## The three ways to use it

### As the license for your own project

Run the installer or the template. Add the attribution notice to your README.

### As a dependency inside a larger product

LGPT-covered code can be linked into, statically or dynamically, and bundled
into proprietary applications. **Your own code stays yours.** You are not
required to open-source anything you wrote. You do have to keep the LGPT notice
with the LGPT-covered part.

```bash
# Node
npm install your-lgpt-package

# Python
pip install your-lgpt-package

# Go / Rust / any ecosystem — copy the NOTICE into your distribution
```

### Re-licensing your own work under LGPT

LGPT is a valid license *for* you to grant. Just ship `LICENSE.txt` and a
`NOTICE`.

---

## Required attribution

This is the one thing you must do. Put this in your README, `NOTICE`, an About
dialog, a Credits page, or wherever fits your project:

```text
This project contains software licensed under the LGPT License v1.0.

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
```

For small libraries, CLI tools, or embedded components where a full block is
impractical, a one-line reference to the license and its URL in your README,
`AUTHORS`, or legal-notices file satisfies §6.

---

## Badge

```markdown
[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](https://github.com/Ali-A-Alwahed/LGPT)
```

Renders as:

[![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](https://github.com/Ali-A-Alwahed/LGPT)

---

## File map

| File | Purpose |
|---|---|
| [`LICENSE.txt`](LICENSE.txt) | The license text. **Do not modify.** |
| [`NOTICE`](NOTICE) | Attribution notice template |
| [`AUTHORS`](AUTHORS) | Creator and contributor record |
| [`SPDX.md`](SPDX.md) | SPDX metadata and licensing identifier |
| [`scripts/install-lgpt.sh`](scripts/install-lgpt.sh) | One-command installer |
| [`action.yml`](action.yml) | GitHub Action definition |
| [`docs/ADOPTING.md`](docs/ADOPTING.md) | Detailed adoption guide |
| [`docs/COMPARISON.md`](docs/COMPARISON.md) | Long-form comparison with other licenses |
| [`docs/FAQ.md`](docs/FAQ.md) | Common questions |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | How to contribute to this repo |
| [`LICENSE.txt` checksum](SHA256SUMS) | Integrity verification for the license text |

---

## FAQ

**Is LGPT an OSI-approved open source license?**
No. It is a permissive, free-software license, but it is not on the OSI list. If your organisation's policy requires OSI approval, use MIT or Apache-2.0 instead.

**Is this related to the GNU LGPL?**
No. Completely unrelated. The acronyms are similar and the resemblance is coincidental.

**Can I use it commercially?**
Yes, without paying royalties. See §3 and §5.

**Do I have to open-source my project?**
No. See §9. Keep your proprietary code private.

**Can I modify it?**
Yes. See §8. Substantial modifications must be marked as such.

**Does it really grant a patent license?**
Yes, §15 — with a termination clause if you sue the project over patents.

**Does it stop me from being spammed with telemetry?**
It grants no right to collect or transmit user data, §12. It cannot technically prevent a distributor from shipping telemetry in *their own* code, but it makes such processing unauthorised under this license.

**Do I need to open an issue to use it?**
No. No registration, no approval, no CLA. Use it today.

**What if my company blocks unapproved licenses?**
That is a policy decision on their side, not a defect in the license. Apache-2.0 or MIT will pass; LGPT will not. Nothing in this license requires you to misrepresent it as something it is not.

More in **[docs/FAQ.md](docs/FAQ.md)**.

---

## Contributing

Contributions are welcome — clarifications, translations, legal review,
real-world adoption reports, and tooling. See
[CONTRIBUTING.md](CONTRIBUTING.md).

**Important:** the license text in `LICENSE.txt` is the canonical document.
Any PR that modifies it must be intentional, discussed in an issue first, and
will bump the version number.

---

## Author

**Ali A Alwahed**

[![GitHub](https://img.shields.io/badge/GitHub-Ali--A--Alwahed-181717?style=for-the-badge&logo=github)](https://github.com/Ali-A-Alwahed)
[![Website](https://img.shields.io/badge/Website-sonzaistudios.org-8A2BE2?style=for-the-badge)](https://sonzaistudios.org)

---

## ⚖️ License

The license text in [`LICENSE.txt`](LICENSE.txt) is licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) so it can be freely
copied and shared. The accompanying tooling, Action, and installer script are
licensed under the MIT License — see [`LICENSE-MIT.txt`](LICENSE-MIT.txt).

<div align="center">

**⭐ If you find LGPT useful, star the repo — it is the single biggest factor in whether others discover it.**

</div>