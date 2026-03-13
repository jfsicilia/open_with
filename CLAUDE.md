# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Single-file bash script (`open_with.sh`) that presents a rofi dmenu picker to open a path/URL in one of several applications (Chrome, terminal via foot, or Neovim). Designed to be invoked from minimal environments like kanata keybindings that lack full desktop session variables.

## Running

```bash
./open_with.sh [path_or_url]
```

Requires: `rofi`, `google-chrome`, `foot` (terminal), `nvim`. Targets a Wayland/KDE desktop on Linux (Fedora).

## Key Details

- Environment block at the top ensures Wayland/KDE/D-Bus variables are set when launched from minimal contexts (e.g. kanata hotkeys).
- Uses `rofi -dmenu` with `-matching prefix -auto-select` so single-letter prefixes (m/t/v) act as quick-select keys.
- Arguments (`$@`) are passed unquoted to the selected application — this is intentional for the current use case but worth noting.
