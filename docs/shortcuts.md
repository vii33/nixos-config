# Keyboard Shortcuts & Abbreviations

## Fish Shell Abbreviations

These shell abbreviations are configured in `modules/home/fish-shell.nix`.

| Abbreviation | Expands To | Notes |
|---|---|---|
| `nv` | `nvim` | Declared via `shellAbbrs` |
| `nbl` | `sudo nixos-rebuild switch --flake ~/nixos-config/.#laptop` | Convenience rebuild shortcut |

## Fish Shell Keyboard Shortcuts

These keyboard shortcuts are configured in `modules/home/fish-shell.nix`. Some require additional plugins like `fzf`, `tide`, and `sudope`.

| Key | Action | Notes |
|---|---|---|
| Ctrl+L | kill whole line (`kill-whole-line`) | Works in insert mode too |
| Ctrl+S | clear screen (`clear-screen`) | Repurposes traditional flow-control key |
| Ctrl+Right | forward-word | |
| Ctrl+Left | backward-word | |
| Ctrl+B | run `fzf_bindings` fuzzy key search | Custom function; requires `fzf` |
| Ctrl+P | fzf `--processes`  | |
| Ctrl+F | fzf directory  |  |
| Alt+S | Inserts `sudo` (plugin-sudope)  |     |

## Kitty Terminal Shortcuts

These keyboard shortcuts are configured in `modules/home/kitty.nix`.

### Tab Management

| Key | Action |
|---|---|
| Ctrl+Shift+T | new tab |
| Ctrl+Shift+Q | close tab |
| Ctrl+Shift+Right | next tab |
| Ctrl+Shift+Left | previous tab |

### Window Management

| Key | Action |
|---|---|
| Ctrl+Shift+Enter | new window in current working directory |
| Ctrl+Shift+W | close window |

### Copy & Paste

| Key | Action |
|---|---|
| Ctrl+C | copy or interrupt |
| Ctrl+V | paste from clipboard |

### Font Size

| Key | Action |
|---|---|
| Ctrl+Shift++ | increase font size by 1.0 |
| Ctrl+Shift+- | decrease font size by 1.0 |
| Ctrl+Shift+0 | reset font size to default |

## FZF (Fuzzy Finder) Shortcuts

These shortcuts work when inside an FZF search list. Configured via `FZF_DEFAULT_OPTS`.

| Key | Action | Notes |
|---|---|---|
| Ctrl+J | move down one item | Only inside fzf |
| Ctrl+K | move up one item | Only inside fzf |
| Ctrl+U | half-page up | Only inside fzf |
| Ctrl+D | half-page down | Only inside fzf |
| Enter | accept selection | Only inside fzf |
