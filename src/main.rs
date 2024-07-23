// SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
// SPDX-License-Identifier: Apache-2.0
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")] // hide console window on Windows in release

use eframe::egui;
use log::debug;
use std::env;
use std::path::PathBuf;
use std::process::Command;
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

fn get_test_dir() -> PathBuf {
    env::temp_dir().join("deckcheatz-test")
}

fn get_prefix_dir() -> PathBuf {
    get_test_dir().join("proton-prefix")
}

fn get_proton() -> Proton {
    let test_dir = get_test_dir();

    if !test_dir.exists() {
        std::fs::create_dir_all(&test_dir).expect("Failed to create test directory");
    }

    let proton_dir = test_dir.join(CUSTOM_PROTON.0);

    if !proton_dir.exists() {
        Command::new("curl")
            .arg("-L")
            .arg("-s")
            .arg(CUSTOM_PROTON.1)
            .arg("-o")
            .arg(test_dir.join("proton.tar.gz"))
            .output()
            .expect("Failed to download proton. Curl is not available?");

        Command::new("tar")
            .arg("-xf")
            .arg("proton.tar.gz")
            .current_dir(test_dir)
            .output()
            .expect("Failed to extract downloaded proton. Tar is not available?");
    }

    Proton::new(proton_dir, None).with_prefix(get_prefix_dir())
}

fn create_prefix() -> Result<()> {
    let proton = get_proton();

    proton.update_prefix(None::<&str>)?;

    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    // Tokio should be active.
    // Init base app.
    init_app()?;

    // Logging initialized.
    // Error handling initialised.

    _ = create_prefix()?;
    let proton = get_proton();

    proton.wine().run("cmd.exe")?;

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
