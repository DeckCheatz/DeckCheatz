<!--
SPDX-FileCopyrightText: 2024-2026 The DeckCheatz Developers

SPDX-License-Identifier: Apache-2.0
-->

# AGENTS.md

Instructions for AI coding agents working in this repository.

## Project

DeckCheatz is a portable, Flatpak-ready game trainer interface for Steam
Deck and other Linux systems, written in Rust. See `docs/design.md` for the
architecture.

## Build & test

- `cargo build` / `cargo test` / `cargo clippy` / `cargo fmt -- --check` for
  the default host target.
- CI builds and tests against the `x86_64-unknown-linux-musl` target via
  [`cross`](https://github.com/cross-rs/cross) — `cross build
  --target=x86_64-unknown-linux-musl` matches what
  `.github/workflows/ci-tests-linux.yml` runs.
- `nix flake check` / `nix build` validate the Nix packaging
  (`.github/workflows/ci-tests-nix.yml`).

## Conventions

- Commit messages and PR titles must follow [Conventional
  Commits](https://www.conventionalcommits.org/) — enforced by
  `verify-pr-commit.yml`.
- Every file needs SPDX licensing info (`SPDX-FileCopyrightText` +
  `SPDX-License-Identifier`, inline or via a `.license` sidecar file) —
  enforced by `verify-reuse-compliance.yml`. Run `reuse lint` locally to
  check.
- The crate itself is AGPL-3.0-only; most repo infrastructure (workflows,
  docs, config) is Apache-2.0 — match whatever's already used in similar
  files, or check `LICENSES/` for what's available.

## Branching & releases

- `main` is the active development branch.
- Yearly release lines live on `release/<year>.x` branches (e.g.
  `release/2026.x`); tags cut from them follow `v<year>.<n>` (e.g.
  `v2026.1`).
- To backport a merged `main` PR to a release branch, add a
  `backport release/<year>.x` label to it — `backport.yml` cherry-picks it
  and opens a PR automatically.

## Merging

- This repo uses Mergify's merge queue. Don't merge PRs manually via the
  GitHub UI — see `.github/mergify.yml`.

## AI/LLM use

See [`AI_POLICY.md`](AI_POLICY.md). Short version: LLM-assisted
contributions are welcome, but a human must drive and review every step —
no agentised/autonomous submissions — and please respond to review feedback
yourself.
