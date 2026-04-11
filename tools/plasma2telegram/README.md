# plasma2telegram

Generate a Telegram Desktop theme from the active KDE Plasma palette.

This tool reads the current Plasma colors from `~/.config/kdeglobals`, detects
the current desktop light/dark mode from `gsettings`, and rewrites a Telegram
theme template so Telegram follows the same overall palette and accent direction
as the rest of the desktop.

In this dotfiles repo, the implementation lives in this `tools/` directory while
a small launcher command is exposed through Stow at
[`scripts/.local/bin/plasma2telegram-watch`](/home/blacksuan19/.dotfiles/scripts/.local/bin/plasma2telegram-watch).

## Features

- Generates a Telegram Desktop `.tdesktop-theme` from the current KDE Plasma
  palette
- Supports separate light and dark templates with automatic mode selection
- Preserves the template archive layout and background member name
- Generates a solid wallpaper background that matches the derived base surface
- Watches both `gsettings` appearance changes and `kdeglobals` updates
- Prints refresh status while running in watch mode
- Includes targeted overrides for Telegram-specific UI pieces such as:
  - overlays and media chips
  - service pills and date chips
  - sidebar badges and folder rail colors
  - floating action buttons like the "go to bottom" control
  - compose/send icon contrast

## Inputs

The generator uses two different sources of truth:

- `gsettings get org.gnome.desktop.interface color-scheme`
  - used to determine whether the desktop is currently in `light` or `dark` mode
- `~/.config/kdeglobals`
  - used to read actual Plasma colors.

This split is important: `gsettings` tells the tool which mode to use, while
`kdeglobals` provides the real palette values used to recolor the Telegram
theme.

## Files

- [`plasma2telegram.py`](/home/blacksuan19/.dotfiles/tools/plasma2telegram/plasma2telegram.py)
  - main generator
- [`material-template-dark.tdesktop-theme`](/home/blacksuan19/.dotfiles/tools/plasma2telegram/material-template-dark.tdesktop-theme)
  - dark-mode Telegram base template
- [`material-template-light.tdesktop-theme`](/home/blacksuan19/.dotfiles/tools/plasma2telegram/material-template-light.tdesktop-theme)
  - light-mode Telegram base template
- [`plasma2telegram-watch`](/home/blacksuan19/.dotfiles/scripts/.local/bin/plasma2telegram-watch)
  - user-facing launcher installed to `~/.local/bin`

## Preferred Usage

After Stow, the intended entrypoint is:

```bash
plasma2telegram-watch
```

The launcher:

- resolves the repository path even when run through a symlink in `~/.local/bin`
- uses the bundled light and dark templates from `tools/plasma2telegram`
- writes the generated theme to:
  - `~/.local/state/plasma2telegram/plasma-auto.tdesktop-theme`
- starts the generator in `--watch` mode

This is the easiest way to run the tool because you do not need to know the repo
location or pass template paths manually.

## Direct Usage

You can also run the Python script directly:

```bash
python3 tools/plasma2telegram/plasma2telegram.py \
  --template-dark tools/plasma2telegram/material-template-dark.tdesktop-theme \
  --template-light tools/plasma2telegram/material-template-light.tdesktop-theme \
  --output ~/.local/state/plasma2telegram/plasma-auto.tdesktop-theme
```

Run continuously:

```bash
python3 tools/plasma2telegram/plasma2telegram.py \
  --template-dark tools/plasma2telegram/material-template-dark.tdesktop-theme \
  --template-light tools/plasma2telegram/material-template-light.tdesktop-theme \
  --output ~/.local/state/plasma2telegram/plasma-auto.tdesktop-theme \
  --watch
```

Use one template for both modes:

```bash
python3 tools/plasma2telegram/plasma2telegram.py \
  --template path/to/theme.tdesktop-theme \
  --output ~/.local/state/plasma2telegram/custom.tdesktop-theme
```

Print debug palette values:

```bash
python3 tools/plasma2telegram/plasma2telegram.py \
  --template-dark tools/plasma2telegram/material-template-dark.tdesktop-theme \
  --template-light tools/plasma2telegram/material-template-light.tdesktop-theme \
  --output ~/.local/state/plasma2telegram/plasma-auto.tdesktop-theme \
  --debug
```

## CLI Reference

```text
--template          Single template for both light and dark mode
--template-dark     Template to use in dark mode
--template-light    Template to use in light mode
-o, --output        Output .tdesktop-theme path
-k, --kdeglobals    Path to kdeglobals (defaults to ~/.config/kdeglobals)
--watch             Regenerate on desktop appearance changes
--debug             Print detected palette values
```

## Using The Generated Theme In Telegram

Telegram Desktop expects the theme file to stay at a stable path if you want it
to keep updating cleanly while the generator rewrites it.

The intended setup is:

1. Run `plasma2telegram-watch`
2. Send the generated theme file in any Telegram chat from:
   - `~/.local/state/plasma2telegram/plasma-auto.tdesktop-theme`
3. Open that sent theme message and apply the theme
4. Keep using that same generated file path and filename

Because the launcher always rewrites the same file in the same location,
Telegram can automatically pick up changes and recolor the app when the system
theme changes.

In short: send and apply the generated theme once, then let the watcher keep
rewriting that same file.

## Output

The generator writes a Telegram `.tdesktop-theme` file to the output path you
choose.

In the default launcher setup, that file is:

- `~/.local/state/plasma2telegram/plasma-auto.tdesktop-theme`

The important part is that the file keeps the same name and stays in the same
location, so Telegram can keep picking up updates when the watcher regenerates
it.

## Watch Mode

Watch mode listens to:

- `gsettings monitor org.gnome.desktop.interface`
- file signature changes on `kdeglobals`

On refresh it:

1. reads the current mode and Plasma palette
2. chooses the appropriate template for that mode
3. regenerates the Telegram theme
4. prints a status line with the chosen template and mode

If a watch trigger fires but the actual palette/template signature did not
change, the tool prints a skipped-refresh message instead of rewriting the
output.

## Requirements

- Python 3
- `gsettings`
- a KDE Plasma setup with `~/.config/kdeglobals`
- Telegram Desktop themes as input templates

## Repo Layout

This tool is intentionally split into two layers:

- `tools/plasma2telegram/`
  - repo-owned implementation and template assets
- `scripts/.local/bin/plasma2telegram-watch`
  - stowed user-facing command

This keeps internal assets out of the Stow surface while still exposing an easy
command in the standard `~/.local/bin` path.
