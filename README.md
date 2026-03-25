<h1 align="center">KVC-HV-Launcher</h1>

<p align="center">
Single-file launcher helper for Windows 11 that checks prerequisites, runs launch flow, and restores settings automatically.
</p>

<hr>

## ⚠️ Important


> - **Windows 10/11 only**: this script is designed to work on Windows 10/11.
> - **Testing and educational purposes only**.
> - By using this project, you accept full responsibility for your actions and system state.
> - Authors/contributors are **not responsible** for damage, data loss, account issues, bans, or other consequences.

---

## 🚀 Overview

This tool automates a launch flow that:
- validates prerequisites,
- applies a temporary DSE bypass,
- starts your game launcher,
- restores settings after launch.

✅ Compatible with **DenuvOwO** releases.

---

## ⚙️ What It Does

- Re-launches itself minimized.
- Ensures it runs as Administrator (restarts elevated if needed).
- Checks Windows Core Isolation (Memory Integrity):
  - If enabled, it stops and asks you to disable it and reboot first.
- Checks whether MSI Afterburner is running:
  - If running, it closes it and remembers to restart it later.
- Runs `kvc.exe dse off --safe` to disable DSE.
- Searches recursively for one launcher executable:
  - `HV-StartGame.exe`
  - `hypervisor-launcher.exe`
  - `steamclient_loader_x64.exe`
  - `launcher.exe`
  - `HypervisorLauncher.exe`
- Starts the first launcher it finds.
- Waits, then runs `kvc.exe dse on --safe` to re-enable DSE.
- Restarts MSI Afterburner if it was previously running.

---

## ✅ Requirements

- Windows 10/11
- VBS disabled
- Administrator rights

---

## 🧩 How to Use

1. Make sure VBS is off.
2. Move `KVC-HV-Launcher.bat` into the main game folder near the crack. (for example: `BlackMythWukong\b1\Binaries\Win64`).
4. Run `KVC-HV-Launcher.bat`.
5. Launch and play 🎮

---

## 📝 Notes

- DSE patching method is based on [KVC By Wesmar](https://github.com/wesmar/kvc).
- The script downloads `kvc.7z`, extracts `kvc.exe`, and uses it to toggle DSE.
- Tested with: Will work on almost any game but if you find an error with a game please raise an issue
