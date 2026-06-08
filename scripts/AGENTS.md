# Dotfiles Scripts

Collection of general-purpose utility scripts for an Arch Linux / Hyprland desktop.

## Script Index

| Script | Purpose | Key Dependencies |
|--------|---------|-----------------|
| `capture.sh` | Screenshot tool (Screen/Window/Region/Clipboard) | slurp, grim, swappy, hyprctl |
| `fman.sh` | File manager launcher via dmenu | dmenu |
| `fparu.sh` | Package search/install via paru + dmenu | paru, dmenu |
| `fshow.sh` | Show file info | (lightweight script) |
| `fzf.sh` | FZF config/setup | fzf |
| `git-check.sh` | Git status check | git |
| `monitor_cpu.sh` | CPU monitoring | (lightweight script) |
| `network.sh` | WiFi network status with signal bars | iwconfig, iproute2 |
| `play.sh` | Media player launcher via dmenu + mpv | mpv, dmenu |
| `poweroff.sh` | Power management menu (Poweroff/Reboot/Suspend/Logout) | systemd, loginctl, dmenu |
| `progress_bar.sh` | Progress bar utility | (lightweight script) |
| `screen_res.sh` | Screen resolution display | (lightweight script) |
| `video_wallpaper.sh` | Video wallpaper setup | mpvpaper or similar |
| `volume.sh` | Volume display (pamixer-based) | pamixer |
| `wlroots_video_wallpaper.sh` | Wlroots-based video wallpaper | wlroots tools |

## Conventions

- All scripts are bash (shebang: `#!/bin/bash`)
- Executable scripts have `+x` set
- dmenu-based UIs use `-sb "<color>"` for selection bar color
- Scripts kept short and single-purpose
- Minimal dependencies — prefer lightweight CLI tools over heavy GUI

## Important Notes

- `poweroff.sh` uses `loginctl kill-session` for logout (not hyprctl)
- `capture.sh` works with both Hyprland and wlroots compositors
- `play.sh` accepts `n`/`no` as first arg for audio-only mode (`--no-video`)
- `network.sh` auto-detects the active wifi interface via `ip route`
- Many scripts are designed to be bound to keybinds in Hyprland/Niri config
