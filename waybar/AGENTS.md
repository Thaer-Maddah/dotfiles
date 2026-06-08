# Waybar Configuration

Hyprland/Niri waybar config with Catppuccin Mocha-inspired dark theme and orange accent borders.

## Architecture

- `config.jsonc` — Main waybar config (JSONC with comments). Uses `include` to load modular files
- `style.css` — Main stylesheet. Catppuccin Mocha palette, orange border accents, rounded corners on end modules
- `ModulesCustom` — Custom module definitions (swaync notification center)
- `ModulesGroups` — Module groups (notify group with swaync + dot_update)
- `ModulesWorkspaces` — Hyprland workspace config with extensive window-rewrite icon mappings
- `ModulesWorkspaces-niri` — Niri workspace variant
- `ModulesWorkspaces~` — Older workspace config (backup)
- `old-style.css` — Previous stylesheet (backup)
- `scripts/` — Custom shell/Python scripts for modules:
  - `network.sh` — Network status (returns JSON)
  - `backlight.sh` — Backlight control (increase/decrease/toggle/set)
  - `battery.sh` — Battery status (returns JSON)
  - `keyboard.sh` — Keyboard layout indicator (returns JSON)
  - `waybar-wttr.py` — Weather data from wttr.in (returns JSON)

## Conventions

- Use JSONC format (`//` comments, trailing commas allowed) for config files
- Custom scripts return JSON via `--return-type json` in the module config
- Module paths reference `~/.config/waybar/` — scripts go in `~/.config/waybar/scripts/`
- Module files are included via the `include` array in `config.jsonc`
- CSS uses `#custom-<name>` selectors matching module `name` in config
- Orange (#b55602/orange) border accents on left/top/bottom/right of module blocks
- Backup files keep the tilde suffix (`file~`)

## Important Notes

- The config has both Hyprland (`hyprland/workspaces#rw`) and Niri (`niri/workspaces#rw`) workspace modules — both are active in the bar
- `pulseaudio#microphone` is a separate named instance
- Signal-based updates: `custom/keyboard` uses signal 1, `custom/battery` uses signal 2
- `custom/network` logs to `~/.cache/waybar-network.log`
- Weather script (`waybar-wttr.py`) has a 300s restart interval
- `ModulesWorkspaces` has an extensive icon mapping for window classes/titles
- After editing, reload waybar: `pkill -USR2 waybar` or `killall -SIGUSR2 waybar`
