#!/usr/bin/env bash

# ── Environment ──────────────────────────────────────────────────────────────
# Ensure Wayland/KDE/D-Bus variables are set so the script works correctly
# when launched from minimal environments (e.g. kanata) that don't inherit
# the full desktop session.
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
export XDG_SESSION_TYPE="${XDG_SESSION_TYPE:-wayland}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-KDE}"
export XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-KDE}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"

# ── Helpers ──────────────────────────────────────────────────────────────────

# rofi_menu — Display a rofi dmenu with a given prompt.
# Parameters:
#   $1      — prompt string shown in rofi
#   $@      — additional flags forwarded to rofi (e.g. -i, -multi-select)
# Input:    piped list of options (one per line)
# Output:   selected option(s) to stdout, empty if cancelled
rofi_menu() {
    local prompt="$1"
    shift
    rofi -dmenu -p "$prompt" "$@"
}

app=$(printf 'm. CHROME\nt. TERMINAL\nv. NVIM' |
    rofi_menu "Open with..." -matching prefix -auto-select)

app="${app#*. }" # strip letter prefix (e.g. "o. open" → "open")

case "$app" in
CHROME)
    google-chrome --new-window $@
    ;;
TERMINAL)
    # Open one foot terminal per path argument.
    # If the path is a file, use its parent directory instead.
    for path in "$@"; do
        if [ -f "$path" ]; then
            path="$(dirname "$path")"
        fi
        foot --maximized --working-directory="$path" &
    done
    ;;
NVIM)
    # Pass paths as positional args to the inline bash script.
    # The "--" becomes $0 inside -c; "$@" from the outer script becomes $1, $2, …
    foot --maximized bash -c 'nvim "$@"' -- "$@"
    ;;
esac
