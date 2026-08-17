# Fish Shell Shortcuts & Abbreviations

## Fish Shell Abbreviations

These shell abbreviations are configured in `modules/home/fish-shell.nix`.

| Abbreviation | Expands To | Notes |
|---|---|---|
| `nv` | `nvim` | Declared via `shellAbbrs` |
| `ocl` | `opencode -m github-copilot/gpt-5.6-luna` | OpenCode with Luna selected |
| `oct` | `opencode -m github-copilot/gpt-5.6-terra` | OpenCode with Terra selected |
| `ocs` | `opencode -m github-copilot/claude-sonnet-5` | OpenCode with Sonnet 5 selected |
| `ocss` | sources the OpenCode secret if needed, then runs `opencode serve --hostname 0.0.0.0 --port 4096` | Starts the shared OpenCode server |
| `occ` | sources the OpenCode secret if needed, then runs `opencode attach http://localhost:4096 --password "$OPENCODE_SERVER_PASSWORD" --dir "$PWD"` | Attaches current directory to the shared OpenCode server |
| `nodry` | `nh os dry-run --flake .#laptop` | Preview changes without building |
| `noswitch` | `nh os switch --flake .#laptop` | Apply changes & set as default boot |
| `noclean` | `nh clean all --keep-since 3d --keep 3` | Cleanup old generations |
| `nosearch` | `nh search` | Fast package search |
| `workbuild` | `home-manager switch --flake ~/repos/nixos-config/.#work --impure` | macOS user-level update |
| `hmswitch` | rebuilds Home Manager, detaches Zellij, then removes the current session via a background helper | Fresh Zellij session on next `zz` |
| `workswitch` | `cd ~/repos/nixos-config; and sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work --impure` | macOS system rebuild that persists across restarts |
| `zellijkill` | `zellij kill-all-sessions -y; zellij delete-all-sessions -y` | Kill + delete all Zellij sessions (non-interactive) |

## Fish Shell Keyboard Shortcuts

These keyboard shortcuts are configured in `modules/home/fish-shell.nix`. Some require additional plugins like `fzf`, `tide`, and `sudope`.

| Key | Action | Notes |
|---|---|---|
| `Alt + C` | change oc tab workspace | Uses `fzf` to select a directory, restarts panes there, and reattaches OpenCode with `--dir` |
| `Ctrl + O` | fuzzy pick file and open it in Helix | Works in insert/normal/visual mode |
| `Ctrl + Shift + O` | fuzzy pick file and insert path | Works in insert/normal/visual mode |
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
