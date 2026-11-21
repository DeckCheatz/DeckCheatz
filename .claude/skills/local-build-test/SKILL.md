---
name: local-build-test
description: Run DeckCheatz's Rust and Nix build/test/lint suite locally, mirroring what ci-tests-linux.yml and ci-tests-nix.yml run in CI. Use before pushing changes that touch src/**, Cargo.toml/Cargo.lock, rust-toolchain.toml, or *.nix files.
---

# Local build & test loop

Mirrors `.github/workflows/ci-tests-linux.yml` and
`.github/workflows/ci-tests-nix.yml` so you can catch failures before
pushing.

## Rust (x86_64-unknown-linux-musl)

CI builds and tests against the musl target via `cross`. Install it first
if you don't have it (`cargo install cross` or similar).

```bash
cross test --target=x86_64-unknown-linux-musl
cross check --target=x86_64-unknown-linux-musl
cross clippy --target=x86_64-unknown-linux-musl
cargo fmt -- --check
```

Run all four — CI treats each as a separate required check, so a clippy or
fmt failure blocks merging just as much as a test failure does.

## Nix packaging

```bash
nix flake check --show-trace --impure --print-build-logs --accept-flake-config
nix build --print-build-logs --accept-flake-config
```

`nix build` has been flaky in CI historically — a failure here isn't
automatically project-blocking, but should still be looked at rather than
ignored outright.

## Before pushing

If none of `src/**`, `Cargo.toml`, `Cargo.lock`, `rust-toolchain.toml`, or
`*.nix` changed, CI won't even run these checks (see the `paths:` filter on
`ci-tests.yml`) — no need to run them locally either.
