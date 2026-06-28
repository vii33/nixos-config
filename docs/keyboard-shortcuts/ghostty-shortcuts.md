# Ghostty Terminal Shortcuts

These keyboard shortcuts are configured in `modules/home/ghostty.nix`.

> macOS: Ghostty is configured with `macos-option-as-alt = left` so **Left Option** acts as `Alt`.
> In this repo, Herdr/Zellij own multiplexer navigation, so Ghostty explicitly unbinds
> `Ctrl + Tab`, `Ctrl + Shift + Tab`, and `Alt + 1-9`.
> Split keybindings in Ghostty are disabled (commented out) because Zellij handles panes.
> `Ctrl + Shift + j` is also unbound so terminal apps can use it for half-page down.
> `Ctrl + Alt + j/k` scroll Ghostty's own scrollback. Nested TUIs such as
> OpenCode inside Herdr need matching app-level bindings instead.

## Tab Management

| Key | Action |
|---|---|
| `Ctrl + Shift + t` | new tab |
| `Ctrl + Shift + q` | close tab |
| `Ctrl + Tab` | unbound for Herdr |
| `Ctrl + Shift + Tab` | unbound for Herdr |
| `Ctrl + Alt + j` | scroll down one line |
| `Ctrl + Alt + k` | scroll up one line |
| `Ctrl + Alt + d` | scroll down half page |
| `Ctrl + Alt + u` | scroll up half page |
| `Ctrl + Shift + j` | unbound for terminal apps |
| `Alt + 1-9` | unbound for multiplexer tab navigation |

## Split Management (Kitty "Windows")

| Key | Action |
|---|---|
| `Ctrl + Shift + Enter` | new split (auto direction) |
| `Ctrl + Shift + w` | close split |
| `Ctrl + Shift + ä` | next split |
| `Ctrl + Shift + ö` | previous split |
| `Alt + j` | split down |
| `Alt + k` | split up |

## Copy & Paste

| Key | Action |
|---|---|
| `Ctrl + c` | copy (if selection) or interrupt |
| `Ctrl + v` | paste from clipboard |

## Font Size

| Key | Action |
|---|---|
| `Ctrl + +` | increase font size |
| `Ctrl + -` | decrease font size |
| `Ctrl + Shift + 0` | reset font size |

On US-style layouts, Ghostty also keeps the physical-key variants `Ctrl + Shift + =`
and `Ctrl + Shift + -` bound so the shortcuts still work there.
