// SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
// SPDX-License-Identifier: Apache-2.0

use color_eyre::eyre::{Report, Result};
use log::{debug, info};

use env_logger::{Builder as EnvLoggerBuilder, Env};

fn init_app() -> Result<()> {
    EnvLoggerBuilder::from_env(Env::default().default_filter_or("info")).init();
    debug!("Logger initialized.");

    color_eyre::install()?; // Initialize error handling.
    debug!("Error handling initialized.");

    debug!("Base app initialized.");
    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Report> {
    // Tokio should be active.
    // Init base app.
    init_app()?;

    // Logging initialized.
    // Error handling initialised.

    // Output Steam environment variables.
    use std::env;
    for (k, v) in env::vars() {
        info!("Steam environment variable found: {k}={v}")
    }
    return Ok(());
}
