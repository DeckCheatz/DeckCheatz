// SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
// SPDX-License-Identifier: Apache-2.0
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")] // hide console window on Windows in release

use eframe::egui;
use log::{debug, info};

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

    // Output Steam environment variables.
    use std::env;
    for (k, v) in env::vars() {
        if k.starts_with("STEAM") {
            info!("Steam environment variable found: {k}={v}")
        }
    }

    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default().with_inner_size([320.0, 240.0]),
        ..Default::default()
    };

    _ = eframe::run_simple_native("DeckCheatz", options, move |ctx, _frame| {
        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("DeckCheatz");
            ui.label("Welcome to DeckCheatz!");
            ui.label("This is a work in progress.");
            ui.label("Please check back later.");
        });
    });

    Ok(())
}
