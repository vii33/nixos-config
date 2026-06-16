# Ghostty Terminal Shortcuts

These keyboard shortcuts are configured in `modules/home/ghostty.nix`.

> macOS: Ghostty is configured with `macos-option-as-alt = left` so **Left Option** acts as `Alt`.
> In this repo, Herdr/Zellij own multiplexer navigation, so Ghostty explicitly unbinds
> `Ctrl + Tab`, `Ctrl + Shift + Tab`, and `Alt + 1-9`.
> Split keybindings in Ghostty are disabled (commented out) because Zellij handles panes.

## Tab Management

| Key | Action |
|---|---|
| `Ctrl + Shift + T` | new tab |
| `Ctrl + Shift + Q` | close tab |
| `Ctrl + Tab` | unbound for Herdr |
| `Ctrl + Shift + Tab` | unbound for Herdr |
| `Alt + 1-9` | unbound for multiplexer tab navigation |

## Split Management (Kitty "Windows")

| Key | Action |
|---|---|
| `Ctrl + Shift + Enter` | new split (auto direction) |
| `Ctrl + Shift + W` | close split |
| `Ctrl + Shift + Ä` | next split |
| `Ctrl + Shift + Ö` | previous split |
| `Alt + J` | split down |
| `Alt + K` | split up |

## Copy & Paste

| Key | Action |
|---|---|
| `Ctrl + C` | copy (if selection) or interrupt |
| `Ctrl + V` | paste from clipboard |

## Font Size

| Key | Action |
|---|---|
| `Ctrl + +` | increase font size |
| `Ctrl + -` | decrease font size |
| `Ctrl + Shift + 0` | reset font size |

On US-style layouts, Ghostty also keeps the physical-key variants `Ctrl + Shift + =`
and `Ctrl + Shift + -` bound so the shortcuts still work there.
