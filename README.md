# open_with

A small bash script that presents a [rofi](https://github.com/davatorium/rofi) dmenu picker to open a path or URL in one of several applications:

- **Chrome** — opens in a new window
- **Terminal** — opens a [foot](https://codeberg.org/dnkl/foot) terminal in the path's directory (deduplicates multiple paths in the same folder)
- **Neovim** — opens files in nvim inside a foot terminal

Designed to be invoked from minimal environments (e.g. [kanata](https://github.com/jtroo/kanata) keybindings) that lack full desktop session variables.

## Usage

```bash
./open_with.sh [path_or_url ...]
```

Single-letter prefixes (`m`, `t`, `v`) act as quick-select keys in the rofi menu thanks to `-matching prefix -auto-select`.

## Requirements

- `rofi`
- `google-chrome`
- `foot`
- `nvim`
- Wayland/KDE desktop (Linux)
