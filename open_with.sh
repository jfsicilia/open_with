#!/usr/bin/env bash

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

# ── Menu options ──────────────────────────────────────────────────────────────
# Each entry is "key. LABEL" — the key enables rofi prefix quick-select.
options=(
    "m. CHROME"
    "t. TERMINAL"
    "v. NVIM"
)

# ── Main ─────────────────────────────────────────────────────────────────────

app=$(printf '%s\n' "${options[@]}" |
    rofi_menu "Open with..." -matching prefix -auto-select)

app="${app#*. }" # strip letter prefix (e.g. "m. CHROME" → "CHROME")

case "$app" in
CHROME)
    google-chrome --new-window $@
    ;;
TERMINAL)
    # Open one foot terminal per unique directory.
    # If the path is a file, use its parent directory instead.
    # Deduplicate so multiple files in the same folder don't spawn extra terminals.
    declare -A seen
    for path in "$@"; do
        if [ -f "$path" ]; then
            path="$(dirname "$path")"
        fi
        if [[ -z "${seen[$path]}" ]]; then
            seen[$path]=1
            foot --maximized --working-directory="$path" &
        fi
    done
    ;;
NVIM)
    # Pass paths as positional args to the inline bash script.
    # The "--" becomes $0 inside -c; "$@" from the outer script becomes $1, $2, …
    foot --maximized bash -c 'nvim "$@"' -- "$@"
    ;;
esac
