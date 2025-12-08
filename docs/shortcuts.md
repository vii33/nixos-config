# Keyboard Shortcuts & Abbreviations

## Fish Shell Abbreviations

These shell abbreviations are configured in `modules/home/fish-shell.nix`.

| Abbreviation | Expands To | Notes |
|---|---|---|
| `nv` | `nvim` | Declared via `shellAbbrs` |
| `nodry` | `nh os dry-run --flake .#laptop` | Preview changes without building |
| `noswitch` | `nh os switch --flake .#laptop` | Apply changes & set as default boot |
| `noclean` | `nh clean all --keep-since 3d --keep 3` | Cleanup old generations |
| `nosearch` | `nh search` | Fast package search |

## Fish Shell Keyboard Shortcuts

These keyboard shortcuts are configured in `modules/home/fish-shell.nix`. Some require additional plugins like `fzf`, `tide`, and `sudope`.

| Key | Action | Notes |
|---|---|---|
| `Alt + C` | change to directory | Uses `fzf` to select directory |
| `Ctrl + O` | fuzzy pick file and insert path | Works in insert/normal/visual mode |
| `Ctrl + F` | fzf directory  |  |
| `Ctrl + B` | Key Bindings | Custom function; requires `fzf` |
| `Ctrl + P` | Processes  | requires `fzf` |
| `Ctrl + L` | kill whole line (`kill-whole-line`) | Works in insert mode too |
| `Ctrl + S` | clear screen (`clear-screen`) | Repurposes traditional flow-control key |
| `Ctrl + Right` | forward-word | |
| `Ctrl + Left` | backward-word | |
| `Ctrl + Y` | copy current command line to clipboard | Vim-like; also `yy` in normal mode |
| `Alt + S` | Inserts `sudo` (plugin-sudope)  |     |

## Kitty Terminal Shortcuts

These keyboard shortcuts are configured in `modules/home/kitty.nix`.

### Tab Management

| Key | Action |
|---|---|
| `Ctrl + Shift + T` | new tab |
| `Ctrl + Shift + Q` | close tab |
| `Ctrl + Shift + Right` | next tab |
| `Ctrl + Shift + Left` | previous tab |

### Window Management

| Key | Action |
|---|---|
| `Ctrl + Shift + Enter` | new window in current working directory |
| `Ctrl + Shift + W` | close window |

### Copy & Paste

| Key | Action |
|---|---|
| `Ctrl + C` | copy or interrupt |
| `Ctrl + V` | paste from clipboard |

### Font Size

| Key | Action |
|---|---|
| `Ctrl + Shift + +` | increase font size by 1.0 |
| `Ctrl + Shift + -` | decrease font size by 1.0 |
| `Ctrl + Shift + 0` | reset font size to default |

## Neovim/LazyVim Shortcuts

For the full Neovim / LazyVim shortcuts list, see `docs/neovim-shortcuts.md`.


## FZF (Fuzzy Finder) Shortcuts

These shortcuts work when inside an FZF search list. Configured via `FZF_DEFAULT_OPTS`.

| Key | Action | Notes |
|---|---|---|
| `Ctrl + J` | move down one item | Only inside fzf |
| `Ctrl + K` | move up one item | Only inside fzf |
| `Ctrl + U` | half-page up | Only inside fzf |
| `Ctrl + D` | half-page down | Only inside fzf |
| `Enter` | accept selection | Only inside fzf |

## Niri Window Manager Shortcuts

These keyboard shortcuts are configured in `modules/home/niri.nix`.

### Application Launching

| Key | Action |
|---|---|
| `Super + Return` | launch terminal (kitty) |
| `Super + D` | launch application launcher (fuzzel) |

### Window Management

| Key | Action |
|---|---|
| `Super + Q` | close focused window |
| `Super + Left` / `Super + H` | focus column to the left |
| `Super + Right` / `Super + L` | focus column to the right |
| `Super + Up` / `Super + K` | focus window above |
| `Super + Down` / `Super + J` | focus window below |

### Moving Windows

| Key | Action |
|---|---|
| `Super + Shift + Left` / `Super + Shift + H` | move column left |
| `Super + Shift + Right` / `Super + Shift + L` | move column right |
| `Super + Shift + Up` / `Super + Shift + K` | move window up |
| `Super + Shift + Down` / `Super + Shift + J` | move window down |

### Workspaces

| Key | Action |
|---|---|
| `Super + 1-9` | switch to workspace 1-9 |
| `Super + Shift + 1-9` | move window to workspace 1-9 |

### Window Layout

| Key | Action |
|---|---|
| `Super + R` | cycle through preset column widths |
| `Super + Shift + R` | reset window height |
| `Super + F` | maximize column |
| `Super + Shift + F` | fullscreen window |

### System

| Key | Action |
|---|---|
| `Super + Shift + E` | exit niri |
| `Super + Shift + P` | power off monitors |
| `Print` | screenshot region (to clipboard) |
| `Shift + Print` | screenshot full screen (to clipboard) |

### Media Keys

| Key | Action |
|---|---|
| `XF86AudioRaiseVolume` | increase volume 5% |
| `XF86AudioLowerVolume` | decrease volume 5% |
| `XF86AudioMute` | toggle audio mute |
| `XF86AudioMicMute` | toggle microphone mute |
| `XF86MonBrightnessUp` | increase brightness 5% |
| `XF86MonBrightnessDown` | decrease brightness 5% |

