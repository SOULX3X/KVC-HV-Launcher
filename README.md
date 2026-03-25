<h1 align="center">HV-PlugNPlay</h1>

<p align="center">
Single-file launcher helper for Windows 11 that checks prerequisites, runs launch flow, and restores settings automatically.
</p>

<hr>

## ⚠️ Important


> - **Windows 11 only**: this script is designed to work on Windows 11.
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
- Runs `drvloader.exe bypass` to disable DSE.
- Searches recursively for one launcher executable:
  - `HV-StartGame.exe`
  - `hypervisor-launcher.exe`
  - `steamclient_loader_x64.exe`
  - `launcher.exe`
  - `HypervisorLauncher.exe`
- Starts the first launcher it finds.
- Waits, then runs `drvloader.exe restore` to re-enable DSE.
- Restarts MSI Afterburner if it was previously running.

---

## ✅ Requirements

- Windows 11
- VBS disabled
- Administrator rights

---

## 🧩 How to Use

1. Make sure VBS is off.
2. Move `HV-PlugNPlay.bat` into the main game folder (for example: `BlackMythWukong`).
3. ⚠️ **IMPORTANT: DO NOT place it next to the crack folder/files.**
4. Run `HV-PlugNPlay.bat`.
5. Launch and play 🎮

---

## 📝 Notes

- DSE patching method is based on [KernelResearchKit](https://github.com/wesmar/KernelResearchKit).
- The script downloads `KernelResearchKit.7z`, extracts `drvloader.exe`, and uses it to toggle DSE.
- Tested with: Stellar Blade, Black Myth Wukong, Crimson Desert, Mafia The Old Country, Resident Evil Requiem, Persona 4 Golden (DenuvOwO Edition) on 24H2 and 25H2.

---

## 🙏 Credits

- Special thanks to [@Verix](https://github.com/jcnnlk) and [@SOULX3X](https://github.com/SOULX3X) for contributing to the script and testing on multiple games.
