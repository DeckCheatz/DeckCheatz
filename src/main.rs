// SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
// SPDX-License-Identifier: Apache-2.0

use color_eyre::eyre::{Report, Result};
use log::debug;

#[cfg(not(debug_assertions))]
use std::io;

#[cfg(debug_assertions)]
use std::env;

fn init_app() -> Result<()> {
    env_logger::init(); // Initialize logger.
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

    #[cfg(not(debug_assertions))]
    return Err(io::Error::new(
        io::ErrorKind::Other,
        "This program is a WIP!",
    ))?;

    #[cfg(debug_assertions)]
    {
        // Output Steam environment variables.
        for (k, v) in env::vars() {
            info!("Steam environment variable found: {k}={v}")
        }
        return Ok(());
    }
}
