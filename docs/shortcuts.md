# Keyboard Shortcuts

This repo keeps shortcut references in `docs/keyboard-shortcuts/`:

- Fish: [docs/keyboard-shortcuts/fish-shell-shortcuts.md](keyboard-shortcuts/fish-shell-shortcuts.md)
  - Includes custom pickers like `Ctrl + E` for environment variables.
- Herdr: [docs/keyboard-shortcuts/herdr-shortcuts.md](keyboard-shortcuts/herdr-shortcuts.md)
- Kitty: [docs/keyboard-shortcuts/kitty-shortcuts.md](keyboard-shortcuts/kitty-shortcuts.md)
- Ghostty: [docs/keyboard-shortcuts/ghostty-shortcuts.md](keyboard-shortcuts/ghostty-shortcuts.md)
- Neovim/LazyVim: [docs/keyboard-shortcuts/neovim-shortcuts.md](keyboard-shortcuts/neovim-shortcuts.md)
- Niri: [docs/keyboard-shortcuts/niri-shortcuts.md](keyboard-shortcuts/niri-shortcuts.md)
- Yazi: [docs/keyboard-shortcuts/yazi-keybindings.md](keyboard-shortcuts/yazi-keybindings.md)

## Global

| Key | Action |
|---|---|
| `Caps Lock` | Emits `F18` on the laptop via `services.keyd`; used as Herdr prefix |
| `Ctrl + H` | Toggle hidden files in GNOME Files / Nautilus |

## Fish shell

See the [complete Fish shortcut reference](keyboard-shortcuts/fish-shell-shortcuts.md).

| Key / abbreviation | Action |
|---|---|
| `Ctrl + O` | Fuzzy-pick a file and open it in Helix |
| `Ctrl + Shift + O` | Fuzzy-pick a file and insert its escaped path |
| `ocl` / `oct` / `ocs` | Start OpenCode with Luna / Terra / Sonnet 5 |
| `ocss` | Start the shared OpenCode server |

## Yazi

See the [complete Yazi shortcut reference](keyboard-shortcuts/yazi-keybindings.md).

| Key | Action |
|---|---|
| `g` then `O` | Go to `~/.config/opencode` |

## Zellij

Configured in `modules/home/zellij.nix` (default mode: `locked`, toggle with `Ctrl + g`).

| Key | Action |
|---|---|
| `Alt + t` | New tab |
| `Alt + r` | Rename current tab |
| `Alt + Shift + t` | New opencode workspace tab |
| `Alt + w` | Close tab |
| `Alt + a` | Next tab |
| `Ctrl + ö/ä` | Move current tab left/right |
| `Alt + 1..6` | Go to tab 1..6 |
| `Alt + h/j/k/l` | Move focus (left/down/up/right) |
| `Alt + c` | Rebuild current `oc` tab in a chosen directory |
| `Alt + p` | Toggle floating panes |
