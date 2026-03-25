# KVC-HV-Launcher
`KVC-HV-Launcher` is a single file launcher helper script that checks system requirements, starts the game loader, and restores settings afterward (no reboot required during launch flow).

## What it does

- Re-launches itself minimized.
- Ensures it is running as Administrator (restarts elevated if needed).
- Checks Windows Core Isolation (Memory Integrity):
  - If enabled, it stops and asks you to disable it and reboot.
- Checks whether MSI Afterburner is running:
  - If running, it force-closes it and remembers to restart it later.
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

## How to use `KVC-HV-Launcher.bat`

1. Make sure VBS is off.
2. Move `KVC-HV-Launcher.bat` into the game folder near the crack. (for example: `BlackMythWukong\b1\Binaries\Win64\`)
3. Run `KVC-HV-Launcher.bat`.
4. And Play.

## Notes

- DSE Patching Method Based on: [KVC By Wesmar](https://github.com/wesmar/kvc)
- The script auto downloads the `KVC.7z` archive from the github linked above uses it and deletes it after use.
- Tested with: Will work on any game but if there is one please raise an issue.
