# Herdr Shortcuts

Managed declaratively in `modules/home/herdr.nix` as `~/.config/herdr/config.toml`.

Prefix: `Caps Lock` emits `F18` on the laptop via `services.keyd`.

## Custom Bindings

| Action | Key(s) | Notes |
|---|---|---|
| Prefix | `Caps Lock`, `F18` | Laptop maps Caps Lock to F18 |
| New workspace | `Prefix + N` | |
| New tab | `Prefix + T` | |
| Next tab | `Prefix + L` | |
| Previous tab | `Prefix + H` | |
| Go to Space 1..9 | `Prefix + 1..9` | Switches Herdr workspaces |
| Rename tab | `Prefix + R` | Leaves shell `Ctrl + R` history search alone |
| Rename workspace | `Prefix + Shift + R` | |
| Close tab | `Prefix + Shift + X` | |
| Close workspace | `Prefix + D` | |
| Goto picker | `Prefix + G` | |
| Split right | `Prefix + V` | Herdr action `split_vertical` |
| Split horizontal | `Prefix + -` (dash) | |
| Copy mode | `Prefix + C` | |
| Open OpenCode mini | `Prefix + M` | GPT-6 Sol with medium reasoning effort; opens a temporary pane |
| Open Lazygit | `Prefix + Ctrl + G` | Runs `lazygit` in a temporary pane |
| Show keybindings TUI | `Prefix + 0` | Runs the local keybindings TUI in a temporary pane |
| Focus pane left/right | `Prefix + Ctrl + H/L` | |
| Cycle pane next/previous | `Prefix + Tab` / `Prefix + Shift + Tab`, `Prefix + ä` / `Prefix + ö` | |
| Toggle sidebar | `Prefix + Ctrl + B` | |

## Nested OpenCode

OpenCode runs as a full-screen app inside Herdr, so Ghostty's terminal-level
scrollback bindings do not scroll its messages. See the
[OpenCode shortcuts](opencode-shortcuts.md) for message navigation.

## Remaining Prefix Bindings

| Action | Key(s) | Notes |
|---|---|---|
| Help | `Prefix + ?` | |
| Settings | `Prefix + S` | |
| Detach | `Prefix + Q` | Leaves server running |
| Reload config | `Prefix + Ctrl + Shift + R` | |
| Workspace picker | `Prefix + W` | |
| New workspace | `Prefix + Shift + N` | |
| New worktree | `Prefix + Shift + G` | |
| Rename workspace | `Prefix + Shift + W` | |
| Close workspace | `Prefix + D`, `Prefix + Shift + D` | |
| Rename tab | `Prefix + R` | |
| Close tab | `Prefix + Shift + X` | |
| Rename pane | `Prefix + Shift + P` | |
| Edit scrollback | `Prefix + E` | |
| Move pane focus | `Prefix + J/K` | Down/up; left/right freed for prev/next tab |
| Next agent | `Prefix + P` | |
| Previous agent | `Prefix + O` | |
| Next pane | `Prefix + Tab` | |
| Previous pane | `Prefix + Shift + Tab` | |
| Close pane | `Prefix + X` | |
| Zoom pane | `Prefix + Z` | |
| Resize mode | `Prefix + B` | |
| Toggle sidebar | `Prefix + Ctrl + B` | |

Source: https://herdr.dev/docs/keyboard/
