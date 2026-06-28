# Herdr Shortcuts

Configured non-declaratively in `~/.config/herdr/config.toml`.

Prefix: `Caps Lock` emits `F15` on the laptop via `services.keyd`.

## Custom Bindings

| Action | Key(s) | Notes |
|---|---|---|
| Prefix | `Caps Lock`, `F15` | Laptop maps Caps Lock to F15 |
| New tab | `Prefix + T` | |
| Next tab | `Prefix + L` | |
| Previous tab | `Prefix + H` | |
| Go to tab 1..9 | `Prefix + 1..9`, `Ctrl + 1..9` | `Ctrl` variant may depend on terminal encoding |
| Rename tab | `Prefix + R` | Leaves shell `Ctrl + R` history search alone |
| Rename workspace | `Ctrl + Shift + R` | Direct binding |
| Close tab | `Ctrl + Q` | Direct binding |
| Close workspace | `Ctrl + Shift + Q`, `Prefix + D` | Direct binding plus prefix shortcut |
| Goto picker | `Ctrl + G` | Direct binding |
| Next workspace | `Ctrl + J` | Direct binding |
| Previous workspace | `Ctrl + K` | Direct binding |
| Split right | `Prefix + V` | Herdr action `split_vertical` |
| Split horizontal | `Prefix + -` (dash) | |
| Copy mode | `Prefix + C` | |

## Nested OpenCode

OpenCode runs as a full-screen app inside Herdr, so Ghostty's terminal-level
scrollback bindings do not scroll its messages. OpenCode's own
`~/.config/opencode/tui.json` bindings handle message scrolling:

| Action | Key |
|---|---|
| Messages line down | `Ctrl + J` |
| Messages line up | `Ctrl + K` |
| Messages half-page down | `Ctrl + D` |
| Messages half-page up | `Ctrl + U` |

## Remaining Prefix Bindings

| Action | Key(s) | Notes |
|---|---|---|
| Help | `Prefix + ?` | |
| Settings | `Prefix + S` | |
| Detach | `Prefix + Q` | Leaves server running |
| Reload config | `Prefix + Ctrl + Shift + R` | |
| Open notification target | `Prefix + O` | |
| Workspace picker | `Prefix + W` | |
| Goto picker | `Prefix + G` | Also has `Ctrl + G` |
| New workspace | `Prefix + Shift + N` | |
| New worktree | `Prefix + Shift + G` | |
| Rename workspace | `Prefix + Shift + W` | Also has `Ctrl + Shift + R` |
| Close workspace | `Prefix + D`, `Prefix + Shift + D` | Also has `Ctrl + Shift + Q` |
| Rename tab | `Prefix + R` | |
| Close tab | `Prefix + Shift + X` | Also has `Ctrl + Q` |
| Rename pane | `Prefix + Shift + P` | |
| Edit scrollback | `Prefix + E` | |
| Move pane focus | `Prefix + J/K` | Down/up; left/right freed for prev/next tab |
| Next pane | `Prefix + Tab` | |
| Previous pane | `Prefix + Shift + Tab` | |
| Close pane | `Prefix + X` | |
| Zoom pane | `Prefix + Z` | |
| Resize mode | `Prefix + B` | |
| Toggle sidebar | `Prefix + Ctrl + Shift + B` | |

Source: https://herdr.dev/docs/keyboard/
