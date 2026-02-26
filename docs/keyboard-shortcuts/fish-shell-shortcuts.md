# Fish Shell Shortcuts & Abbreviations

## Fish Shell Abbreviations

These shell abbreviations are configured in `modules/home/fish-shell.nix`.

| Abbreviation | Expands To | Notes |
|---|---|---|
| `nv` | `nvim` | Declared via `shellAbbrs` |
| `nodry` | `nh os dry-run --flake .#laptop` | Preview changes without building |
| `noswitch` | `nh os switch --flake .#laptop` | Apply changes & set as default boot |
| `noclean` | `nh clean all --keep-since 3d --keep 3` | Cleanup old generations |
| `nosearch` | `nh search` | Fast package search |
| `workbuild` | `home-manager switch --flake ~/repos/nixos-config/.#work --impure` | macOS user-level update |
| `workswitch` | `cd ~/repos/nixos-config; and darwin-rebuild build --flake .#work --impure; and sudo env "PATH=$PATH" ./result/activate` | macOS system rebuild (build+activate) |
| `zellijkill` | `zellij kill-all-sessions -y; zellij delete-all-sessions -y` | Kill + delete all Zellij sessions (non-interactive) |

## Fish Shell Keyboard Shortcuts

These keyboard shortcuts are configured in `modules/home/fish-shell.nix`. Some require additional plugins like `fzf`, `tide`, and `sudope`.

| Key | Action | Notes |
|---|---|---|
| `Alt + C` | change to directory | Uses `fzf` to select directory |
| `Ctrl + O` | fuzzy pick file and insert path | Works in insert/normal/visual mode |
| `Ctrl + E` | fuzzy pick env var and insert `$VARNAME` | Custom picker; requires `fzf` |
| `Ctrl + F` | fzf directory  |  |
| `Ctrl + B` | Key Bindings | Custom function; requires `fzf` |
| `Ctrl + P` | Processes  | requires `fzf` |
| `Ctrl + L` | kill whole line (`kill-whole-line`) | Works in insert mode too |
| `Ctrl + S` | clear screen (`clear-screen`) | Repurposes traditional flow-control key |
| `Ctrl + Right` | forward-word | |
| `Ctrl + Left` | backward-word | |
| `Ctrl + Y` | copy current command line to clipboard | Vim-like; also `yy` in normal mode |
| `Alt + S` | Inserts `sudo` (plugin-sudope)  |     |
