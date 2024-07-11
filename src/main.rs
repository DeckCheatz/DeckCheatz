// SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
// SPDX-License-Identifier: Apache-2.0

use color_eyre::eyre::{Report, Result};

fn setup_eyre() -> Result<()> {
    Ok(color_eyre::config::HookBuilder::default()
        .issue_url(concat!(env!("CARGO_PKG_REPOSITORY"), "/issues/new"))
        .add_issue_metadata("version", env!("CARGO_PKG_VERSION"))
        .install()?)
}
#[tokio::main]
async fn main() -> Result<(), Report> {
    setup_eyre()?;

    Ok(())
}
