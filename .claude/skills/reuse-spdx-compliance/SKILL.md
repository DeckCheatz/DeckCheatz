---
name: reuse-spdx-compliance
description: Add correct SPDX licensing headers to new or changed files in DeckCheatz, matching what verify-reuse-compliance.yml checks. Use whenever you create a new file in this repo, or whenever `reuse lint` reports a file as missing copyright/licensing information.
---

# REUSE / SPDX compliance

Every file in this repo needs SPDX licensing info, checked by
`verify-reuse-compliance.yml` via the [REUSE](https://reuse.software/)
tool.

## Check compliance

```bash
reuse lint
```

Lists any file missing copyright/licensing info. Run this after adding new
files, before opening a PR.

## Adding headers

For files that support comments (YAML, Rust, Markdown via HTML comments,
etc.), add near the top of the file:

```
SPDX-FileCopyrightText: 2024-2026 The DeckCheatz Developers

SPDX-License-Identifier: <license>
```

wrapped in whatever comment syntax the file type uses (`#`, `//`,
`<!-- -->`, etc.).

For files that don't support comments (JSON, lockfiles, `.vdf`, etc.),
create a `<filename>.license` sidecar file next to it with the same two
lines instead — see `Cargo.lock.license` or `flake.lock.license` for
examples already in the repo.

## Which license

- Apache-2.0 for repo infrastructure: CI workflows, config, docs,
  automation.
- AGPL-3.0-only for the Rust crate's own source (matches `Cargo.toml`'s
  `license` field).
- Check `LICENSES/` for the full list of license texts already vendored in
  this repo (`AGPL-3.0-only`, `Apache-2.0`, `GPL-3.0-only`, `MIT`) — reuse
  one of these rather than introducing a new license unless there's a real
  reason to.
