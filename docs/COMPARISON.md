# LGPT compared to other licenses

This document sets out where LGPT differs from the most common open source
licenses. It is written to be checkable: every claim below cites the section of
the relevant license that supports it.

The short version is that **LGPT grants about what MIT grants**, and adds
express terms for privacy and non-endorsement that mainstream licenses leave
unstated. It is not a copyleft license, and it is not a replacement for MIT.

---

## Category map

```
                        strong copyleft        weak copyleft      permissive
                                 │                     │                 │
LGPT-3.0 ────────────────────────┤                     │           │
AGPL-3.0 ────────────────────────┤                     │           │
                                 │                     │           │
LGPL-3.0 ────────────────────────┼─────────────────────┤           │
MPL-2.0 ─────────────────────────┼─────────────────────┤           │
EPL-2.0 ─────────────────────────┼─────────────────────┤           │
                                 │                     │           │
LGPT ────────────────────────────┼─────────────────────┼───────────┤
Apache-2.0 ──────────────────────┼─────────────────────┼───────────┤
BSD-3-Clause ────────────────────┼─────────────────────┼───────────┤
MIT / ISC ───────────────────────┼─────────────────────┼───────────┤
The Unlicense ───────────────────┼─────────────────────┼───────────┤
```

LGPT sits with the permissive licenses. Its nearest relatives by behaviour are
BSD-3-Clause and Apache-2.0, both of which share its attribution requirement,
patent grant, and patent termination clause.

---

## Feature matrix

| Capability | **LGPT** | MIT | Apache-2.0 | BSD-3 | ISC | MPL-2.0 | LGPL-3.0 | Unlicense |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Commercial use | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Modification | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Distribution (source & binary) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Sell products built on it | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Attribution required** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Keep your own code private** | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | ✅ |
| **Share-alike obligation** | ❌ | ❌ | ❌ | ❌ | ❌ | ⚠️ | ⚠️ | ❌ |
| **Must republish modifications** | ⚠️ | ❌ | ❌ | ❌ | ❌ | ⚠️ | ⚠️ | ❌ |
| **Explicit patent grant** | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ |
| **Patent termination clause** | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **Explicit non-endorsement clause** | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Privacy / no-telemetry clause** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Anti-tivoization clause** | ✅ | ❌ | ⚠️ | ❌ | ❌ | ⚠️ | ✅ | ❌ |
| **Warranty disclaimer** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Liability disclaimer** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Per-violator termination** | ✅ | ❌ | ✅ | ❌ | ❌ | ⚠️ | ⚠️ | ❌ |
| **OSI approved** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **On SPDX license list** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **On GitHub's license dropdown** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Human-readable, 1-page** | ❌ | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ✅ |

---

## Notes on each row

This is where the checkmarks stop being useful and the citations start.

### "Keep your own code private"

LGPT §9 says using an LGPT component "does **not**, by itself, require the
application that uses it to publish its source code." The same is true of MIT
and Apache-2.0.

MPL-2.0 (§3.3) and LGPL-3.0 (§4) are weaker: modifications to *covered files*
must be published, but unrelated files in the same project may stay private. So
"⚠️" is right, but the practical difference between "you never have to publish"
and "you never have to publish *that part*" is larger than the symbol implies.

### "Attribution required"

LGPT §6 requires a conspicuous notice. MIT §"above copyright notice", Apache-2.0
§4(c), BSD-3 §1, ISC, and MPL-2.0 §3.1 all do similar.

The Unlicense is the outlier — it asks you to waive copyright entirely. If
attribution is the point, LGPT is closer to your goal than The Unlicense.

### "Explicit patent grant"

- **Apache-2.0 §3** — grants a patent license, terminates on patent litigation.
- **BSD-3-Clause §2** — grants a patent license, no termination clause.
- **MPL-2.0 §3.3** and **LGPL-3.0 §3** — both include the patent grant.
- **LGPT §15** — grants, excludes modifications and combinations, and terminates
  on litigation.
- **MIT / ISC / Unlicense** — no express grant. There is an argument that
  implied estoppel protects users, and a 2019 MIT advisory concluded that
  express language was the safer choice, but there is no text.

### "Explicit non-endorsement clause"

This row needs care, because "no clause" and "you may not claim endorsement"
are not the same thing.

- **Apache-2.0 §4(b)** — *"The names of the licensors must not be used to
  endorse or promote products derived from this Software without prior written
  permission."* Explicit.
- **BSD-3-Clause §3** — *"Neither the name of the copyright holder nor the names
  of its contributors may be used to endorse or promote products derived from
  this Software without specific prior written permission."* Explicit.
- **LGPT §17, §18** — explicit, and additionally reserves "LGPT" and "LGPT
  License" as names.
- **MIT / ISC / The Unlicense** — grant *no trademark rights at all*, so there
  is nothing in them to misuse. They reach the same outcome by a different
  route.
- **MPL-2.0 / LGPL-3.0** — the FSF's position is that section 6 of the FSF
  style of headers limits this, but the licenses themselves contain no
  explicit clause.

So: ❌ here means "no explicit clause", not "you can claim endorsement".

### "Privacy / no-telemetry clause"

No mainstream license addresses telemetry, tracking, analytics, or personal-data
processing. This is a genuine gap in all of them.

LGPT §12 fills it: the license grants no right to collect, sell, disclose, or
process user data, and forbids falsely claiming the original developer requires
telemetry.

Be clear-eyed about what that buys you. It is a drafting position, not a
technical control. It cannot stop someone shipping analytics in their own code.
It matters for the question "was this authorised?", and for the original
author's ability to defend their name — nothing more.

If you need a hard guarantee, you need code review or a network sandbox.

### "Anti-tivoization clause"

LGPT §19 forbids adding technical or contractual conditions intended to remove
rights the license grants. That is narrow: it does not impose linking duties or
installation-information requirements.

LGPL-3.0 §4 and GPL-3.0 §6 are the strong versions, and they come with
significant obligations. Apache-2.0 is ⚠️ because §4 imposes patent-termination
conditions rather than guaranteeing against added restrictions.

### "Per-violator termination"

MIT, BSD-3, ISC, and The Unlicense have no termination clause at all — breach is
handled by ordinary copyright law, which for a permissive license often means
little practical consequence for downstream users.

LGPT §21 terminates **only the violating party's** rights and preserves rights
already granted to others. This is the mechanism that stops someone from
re-licensing your code onward and stripping attribution.

Apache-2.0 §6 is similar for its §4 conditions.

### Tooling support

This is the row that matters most in practice and it is where LGPT is weakest.

| Tool | Behaviour with `LicenseRef-LGPT-1.0` |
|---|---|
| GitHub license picker | Will not appear. Fixed curated list. |
| SPDX validators | Valid `LicenseRef-` form, but "non-standard" |
| `npm` | Accepts `SEE LICENSE IN <file>`; rejects unknown `LicenseRef-` |
| `pubspec.yaml` (Dart) | Warns — validates against the SPDX list |
| `Cargo` | Accepts `license-file` |
| GitHub dependency graph | May not classify the license |
| Enterprise compliance scanners | Typically flagged "unapproved" |

If your organisation runs automated license compliance, this is a real cost.
LGPT is not "better", it is different, and different has a price.

---

## Honest self-assessment

Stated plainly, because a license page that only flatters itself is marketing,
not documentation.

### What LGPT does not give you that MIT doesn't

Nothing. Every grant in §3 is already made by MIT. If you strip §12, §17, §18
and §19 from LGPT, you have a license very close to MIT with a longer preamble.

### What LGPT gives you that MIT doesn't

1. Express language on privacy and telemetry (§12).
2. An express non-endorsement clause (§17, §18) — outcome-equivalent to MIT's
   silence, but explicit.
3. An express patent grant with termination (§15).
4. An express anti-added-restrictions clause (§19).
5. An express per-violator termination clause (§21).

Items 1 and 2 are what LGPT adds. Items 3–5 exist in Apache-2.0 and BSD-3 too.

### Who should use LGPT

- Someone who wants permissive terms but finds MIT's silence on telemetry
  unsatisfying.
- Someone building a library who wants to guarantee attribution survives
  redistribution (§21).
- Someone who prefers explicitness over implied terms and is comfortable
  accepting reduced tooling support.

### Who should not use LGPT

- Anyone whose employer requires OSI approval or an allowlisted license. Use
  Apache-2.0; it is more capable than LGPT in every dimension and is on every
  list.
- Anyone who needs their license recognised by automated compliance tooling.
  Use MIT or Apache-2.0.
- Anyone who wants maximum legal certainty. A licence reviewed by the SPDX legal
  team and used by thousands of companies carries less risk than one reviewed
  by nobody.

**Apache-2.0 is a better license than LGPT by most measurable criteria.** It is
OSI-approved, SPDX-listed, has an explicit patent grant, has an explicit
non-endorsement clause, and is understood by every legal department on Earth.
The honest case for LGPT is that it is more *readable and explicit* than
Apache-2.0, and that it goes slightly further on privacy. That is a narrow
advantage, and pretending otherwise would be a mistake.

---

## Sources for the comparison

- MIT License — <https://opensource.org/license/mit>
- Apache License 2.0 — <https://www.apache.org/licenses/LICENSE-2.0>
- BSD 3-Clause — <https://opensource.org/license/bsd-3-clause>
- ISC License — <https://opensource.org/license/isc-license-txt>
- MPL 2.0 — <https://www.mozilla.org/media/MPL/2.0/index.txt>
- LGPL-3.0 — <https://www.gnu.org/licenses/lgpl-3.0.html>
- GPL-3.0 — <https://www.gnu.org/licenses/gpl-3.0.html>
- The Unlicense — <https://unlicense.org>
- SPDX License List — <https://spdx.org/licenses/>
- OSI Approved Licenses — <https://opensource.org/licenses>
- LGPT License v1.0 — [`LICENSE.txt`](../LICENSE.txt)

LGPT is an original license. It is **not** a copy of, a modification of, or a
substitute for any license listed above. See §31 of `LICENSE.txt`.