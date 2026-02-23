# Ghostty Terminal Shortcuts

These keyboard shortcuts are configured in `modules/home/ghostty.nix`.

> macOS: Ghostty is configured with `macos-option-as-alt = left` so **Left Option** acts as `Alt`.
> In this repo, Zellij is configured to use `Alt + ...` for tabs/panes, so Ghostty keeps `Alt + ...`
> unbound to let Zellij receive those keypresses.
> Split keybindings in Ghostty are disabled (commented out) because Zellij handles panes.

## Tab Management

| Key | Action |
|---|---|
| `Ctrl + Shift + T` | new tab |
| `Ctrl + Shift + Q` | close tab |
| `Alt + 1-5` | Zellij: jump to tab 1-5 |

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
| `Ctrl + Shift + +` | increase font size |
| `Ctrl + Shift + -` | decrease font size |
| `Ctrl + Shift + 0` | reset font size |
