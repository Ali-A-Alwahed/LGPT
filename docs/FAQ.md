# Frequently Asked Questions

Answers about the LGPT License v1.0. Section references (`§n`) point to
[`LICENSE.txt`](../LICENSE.txt).

---

## General

### Is LGPT an OSI-approved open source license?

No. LGPT is a permissive *free software* license, but it has not been submitted
to or approved by the Open Source Initiative.

In practice this matters for organisations whose policy says "open source
licenses only". If you are buying into such a policy, use MIT or Apache-2.0.
LGPT is for people who are free to choose.

### Is LGPT related to the GNU LGPL?

**No.** They are unrelated licenses with confusingly similar acronyms.

- **LGPL** = GNU Lesser General Public License. Copyleft. Your changes to the
  LGPL-covered library must be published under the LGPL.
- **LGPT** = this license. Permissive. No source-disclosure obligation.

If you arrived here looking for LGPL, this is the wrong repository.

### Why "LGPT" and not something more distinctive?

It was chosen for memorability and brevity. The trade-off is real: the name is
one character away from LGPL, and search results will interleave. If you know of
a substantially better name, open an issue — renaming is possible as long as it
happens before the license reaches wide adoption.

### Is this a OSI-approved or a legal document?

It is a legal document, but it is **not legal advice**. If your situation is
unusual — you are a corporation, you are redistributing on hardware, you have
patents in play — have a lawyer read it. See [FAQ: Is it legally
enforceable?](#is-it-legally-enforceable).

---

## Using the license

### What can I do with it?

Everything in §3: use it for any purpose, modify it, fork it, link it, embed
it, redistribute it, and sell products built on it. No field-of-use restriction
(§4). No royalty, no fee, no subscription, no approval request.

### Do I have to open-source my own code?

No. §9 is explicit: using an LGPT library or component does not by itself
require your application to publish its source. Your proprietary algorithms,
business logic, and application code remain yours.

### Can I really use it commercially?

Yes. §3.12 and §5 permit selling copies, products, services, support, hosting,
or applications that contain or use the Software. You owe no royalties.

### Can I put it in a proprietary app?

Yes. Link statically or dynamically (§3.8, §10), bundle it, ship it. Keep the
LGPT notice with the LGPT-covered part.

### Do I have to do anything to get permission?

No. §3 grants permission automatically on possession of the Software. No
registration, no click-through, no CLA, no permission request.

### What is the one thing I must do?

Keep attribution (§6). Put the notice in your README, `NOTICE`, About dialog,
or Credits page. For small libraries and CLI tools, a one-line reference to the
license and its URL is sufficient.

### Do I have to mark my changes?

Only substantial modifications, per §8.2. Typos, refactors, and adding tests
do not require a "modified" marker. A meaningfully altered fork should say so.

---

## Specific clauses

### What does the privacy clause (§12) actually do?

Be realistic about this: **it is a drafting statement, not a technical control.**
It grants no right to collect, sell, disclose, track, or profile user data, and
it forbids falsely claiming that the original developer requires telemetry.

It does **not** and cannot stop a distributor from shipping analytics in their
own proprietary code. What it does do is mean that such processing is not
authorised by this license, which matters when someone asks "was this
permitted?" and when you are the original author defending your reputation.

If you want a hard technical guarantee against telemetry, you need code review,
a network sandbox, or a copyleft license — not a clause.

### What does the non-endorsement clause (§17, §18) do?

It blocks you from implying that Ali A Alwahed or Sonzaistudios endorses,
sponsors, or guarantees your fork or product, and reserves the names "LGPT" and
"LGPT License" from trademark use.

This is not a real restriction compared to what Apache-2.0 §4(b) and BSD-3
already do. It does mean you cannot name a commercial product "LGPT Pro" and
have that read as official. Use your own branding — §17 explicitly permits it.

### What does the patent grant (§15) mean?

The copyright holder grants a worldwide, royalty-free patent license covering
claims necessarily infringed by the Original Work, **to the extent they hold
the rights to grant it**. It does not cover claims from your modifications or
from combining with unrelated technology.

If you sue the project for patent infringement, your patent grant terminates
(§15). That is the standard Apache-2.0-style defensive termination, and it is
what makes the grant credible.

Note the copyright holder has not stated they hold any patents. If they do not,
§15 grants nothing — but it costs you nothing either.

### Can I add my own restrictions?

Not to LGPT-covered code. §19 forbids adding contractual or technical conditions
intended to remove or materially prevent the rights this license grants.

You are free to impose terms on your **own** code, your own support and hosting
services, and your own trademarks. That is an important distinction: §19 stops
you from re-licensing someone else's freedom away, not from running a business.

### Why does my fork lose rights if I violate the license?

§21 terminates the rights of **the violating party only**. Recipients who got
the software from someone else are unaffected, and rights already validly
granted to others survive.

This is the standard copyleft-safety mechanism, applied to a permissive license
to prevent someone from re-licensing your code to a third party and stripping
attribution.

### Is it really compatible with GPL?

LGPT grants all the rights GPL needs to operate on the software, and adds no
restriction on linking or redistribution. In practice LGPL-licensed code can be
combined into a GPL work.

**We are not making a formal compatibility claim.** Only the FSF and the SPDX
license list can make those authoritatively, and that requires legal review.
If this matters to you, ask a lawyer.

### Do I need to keep the license text unchanged?

Yes. Do not edit `LICENSE.txt`. Ship it verbatim.

If your packaging requires a specific filename (`LICENSE` with no extension),
renaming the file is fine. Editing its *contents* is not.

---

## Practical and legal

### Is it legally enforceable?

The license follows standard enforceability principles: a copyright licence
that grants permission on defined conditions, with termination for breach
(§21). This is the same structure as MIT and Apache-2.0.

It is not OSI-approved, and the SPDX list has not reviewed it. Jurisdictions
differ on how implied terms and good faith are applied. **This is not legal
advice.** For high-stakes commercial use, get a lawyer involved.

### Will my company's legal team approve it?

Probably not automatically. Automated compliance tooling at large companies
maintains allowlists, and a licence they have never seen will be flagged as
"unapproved" regardless of how reasonable its terms are.

This is a real cost, not a defect. Plan for the conversation or use MIT.

### Package registries reject the SPDX identifier. Now what?

Use `LicenseRef-LGPT-1.0` in the expression and ship the full text. If a
specific registry rejects even that, most accept `"SEE LICENSE IN LICENSE.txt"`.

Do **not** label it MIT, Apache-2.0, or "public domain". See
[SPDX.md](../SPDX.md) for details.

### Will GitHub show it in the "Add a license" dropdown?

No. That dropdown is a fixed, curated list. Custom licenses cannot be added to
it, and there is no application process.

If you are creating a repository and want LGPT from the start, use the
[project scaffold](ADOPTING.md#method-1-the-project-scaffold) or the
[installer](ADOPTING.md#method-3-the-installer-script).

### Does it stop anyone from using it commercially, or from forking it?

No, and that is deliberate. §3 and §8 grant both. The obligations are
attribution, notice preservation, and non-endorsement. That is all.

### Can I change the terms for my own project?

You can grant **additional** permissions on top of LGPT in writing (§26). You
cannot retroactively rewrite the license for code already distributed under it,
and you cannot change what LGPT grants its recipients.

---

## Adopting it

### How do I add it to an existing project?

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh | bash
```

Or use the [GitHub Action](ADOPTING.md#method-2-the-github-action). See
[ADOPTING.md](ADOPTING.md) for all methods.

### How do I start a new project with it?

Generate the scaffold:

```bash
curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/generate-template.sh \
  | bash -s -- my-project
```

See [ADOPTING.md](ADOPTING.md#method-1-the-project-scaffold).

### I want to contribute a translation or clarification.

See [CONTRIBUTING.md](../CONTRIBUTING.md). Translations and clarifying
proposals are both welcome.

---

## Still unsure?

Open an issue at
[github.com/Ali-A-Alwahed/LGPT/issues](https://github.com/Ali-A-Alwahed/LGPT/issues).

If your question reveals a genuine ambiguity in the license text, that is a
useful bug report — say so and it will be treated as one.