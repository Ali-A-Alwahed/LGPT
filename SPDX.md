# SPDX License Metadata

## Licensing Identifier

```text
LicenseRef-LGPT-1.0
```

SPDX does not currently list LGPT as a standard identifier. Until it is
submitted to and accepted by the [SPDX license list](https://spdx.org/licenses/),
use the `LicenseRef-` form defined in the
[SPDX specification](https://spdx.github.io/spdx-spec/v2.3/SPDX-license-expressions/).

## Expressing it in your project

For a file covered by this license:

```text
SPDX-License-Identifier: LicenseRef-LGPT-1.0
```

For a project-wide expression:

```text
LicenseRef-LGPT-1.0
```

A combined-work expression, for example a project that includes both an
MIT-licensed dependency and your own LGPT-covered code:

```text
LGPT-1.0 AND MIT
```

> Replace `LGPT-1.0` above with `LicenseRef-LGPT-1.0`. The short form is only
> valid once the identifier is accepted into the SPDX license list.

## Machine-readable metadata

The canonical machine-readable metadata for this license, in the format used by
the SPDX license-list repository, is:

```yaml
licenseListVersion: "3.24"
licenses:
  - licenseId: "LGPT-1.0"
    name: "LGPT License"
    isDeprecated: false
    isOsiApproved: false
    isFsfLibre: false
    reference: "https://github.com/Ali-A-Alwahed/LGPT"
    details:
      - "Permissive, attribution-required license with an express privacy and "
        "no-telemetry clause, an express patent grant, and an express "
        "non-endorsement clause."
      - "Grants unrestricted use, modification, redistribution, and "
        "commercial use. Imposes no copyleft and no source-disclosure "
        "obligation."
      - "Not on the SPDX license list. Until accepted, use the "
        "LicenseRef- form."
```

## Note on package registries

Most registries (`npm`, `PyPI`, `crates.io`, Maven Central, RubyGems) restrict
SPDX identifiers to values present in the SPDX license list. `LicenseRef-`
values are accepted by some and rejected by others.

If your registry rejects `LicenseRef-LGPT-1.0`, the usual workarounds are:

1. Omit the `license` field and ship the full text in the package.
2. Use `"SEE LICENSE IN LICENSE.txt"`, which several registries accept as free text.
3. Use `UNLICENSED` or `SEE LICENSE IN ...` depending on the registry's conventions.

Do **not** label your package as MIT, Apache-2.0, or "public domain" if it is
not. That is a misrepresentation of the license you actually grant.

## Registering LGPT with SPDX

Contributions toward a standards-track submission are welcome. The process is
documented at [spdx.org/licenses](https://spdx.org/licenses/). A submission
requires a canonical license text, an SPDX license expression, and a reference
URL — all of which this repository provides.

## Verifying you have the right text

The canonical `LICENSE.txt` has a published SHA-256 digest recorded in
[`SHA256SUMS`](SHA256SUMS). Verify it with:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```

Or use the installer or GitHub Action, both of which can verify automatically.