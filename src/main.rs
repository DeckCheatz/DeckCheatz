// SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
// SPDX-License-Identifier: Apache-2.0
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")] // hide console window on Windows in release

use eframe::egui;
use log::debug;
use std::env;
use std::fs::canonicalize;
use std::path::PathBuf;
use wincompatlib::prelude::*;

use env_logger::{Builder as EnvLoggerBuilder, Env};

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

const CUSTOM_PROTON: (&str, &str) = ("GE-Proton9-1", "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton9-1/GE-Proton9-1.tar.gz");

fn init_app() -> Result<()> {
    EnvLoggerBuilder::from_env(Env::default().default_filter_or("info")).init();
    debug!("Logger initialized.");

    debug!("Base app initialized.");
    Ok(())
}

fn get_proton() -> Result<Proton> {
    let prefix_dir = PathBuf::from(env::var("STEAM_COMPAT_DATA_PATH")?);
    let proton_dir = canonicalize(&PathBuf::from(
        "~/.local/share/Steam/compatibilitytools.d/GE-Proton9-1",
    ))?;

    let proton = Proton::new(proton_dir, None).with_prefix(prefix_dir);
    proton.update_prefix(None::<&str>)?;

    Ok(proton)
}

#[tokio::main]
async fn main() -> Result<()> {
    // Tokio should be active.
    // Init base app.
    init_app()?;

    // Logging initialized.
    // Error handling initialised.

    let proton = get_proton()?;
    proton.wine().run("cmd")?;

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
