// SPDX-FileCopyrightText: 2024-2026 The DeckCheatz Developers
// SPDX-License-Identifier: AGPL-3.0-only

use log::debug;

use env_logger::{Builder as EnvLoggerBuilder, Env};

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

fn init_app() -> Result<()> {
    EnvLoggerBuilder::from_env(Env::default().default_filter_or("info")).init();
    debug!("Logger initialized.");

    debug!("Base app initialized.");
    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    // Tokio should be active.
    // Init base app.
    init_app()?;

    // Logging initialized.
    // Error handling initialised.

    Ok(())
}
