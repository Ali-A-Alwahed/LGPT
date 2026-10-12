## What this changes

<!-- One sentence. If it touches LICENSE.txt, say which section and whether it bumps the version. -->

## Why

<!-- What is unclear, wrong, or missing today? -->

## Type

- [ ] Documentation only
- [ ] Tooling (`scripts/`, `src/`, `.github/`)
- [ ] `LICENSE.txt` — **requires an issue first, and a version bump**

## Verification

<!-- Required if you touched the license text, installer, or Action. -->

```bash
./scripts/ci-check.sh
```

<details>
<summary>Paste output here</summary>

```
```

</details>

## Checklist

- [ ] I ran `./scripts/refresh-checksums.sh` if I changed `LICENSE.txt`
- [ ] I ran `./scripts/build-action.sh` if I changed `src/index.js`
- [ ] This is one focused change, not several bundled together
- [ ] I did not renumber any section in `LICENSE.txt` without updating the FAQ, the comparison doc, and the README
- [ ] I read `CONTRIBUTING.md`