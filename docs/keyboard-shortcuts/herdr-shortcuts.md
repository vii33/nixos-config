# Herdr Shortcuts

Configured non-declaratively in `~/.config/herdr/config.toml`.

Prefix: `Caps Lock` emits `F15` on the laptop via `services.keyd`.

## Custom Bindings

| Action | Key(s) | Notes |
|---|---|---|
| Prefix | `Caps Lock`, `F15` | Laptop maps Caps Lock to F15 |
| New tab | `Prefix + C` | |
| Next tab | `Ctrl + Tab` | Ghostty must leave it unbound |
| Go to tab 1..9 | `Prefix + 1..9`, `Ctrl + 1..9` | `Ctrl` variant may depend on terminal encoding |
| Rename tab | `Prefix + T` | Leaves shell `Ctrl + R` history search alone |
| Rename workspace | `Ctrl + Shift + R` | Direct binding |
| Close tab | `Ctrl + Q` | Direct binding |
| Close workspace | `Ctrl + Shift + Q`, `Prefix + D` | Direct binding plus prefix shortcut |
| Goto picker | `Ctrl + G` | Direct binding |
| Next workspace | `Ctrl + J` | Direct binding |
| Previous workspace | `Ctrl + K` | Direct binding |
| Split right | `Prefix + V` | Herdr action `split_vertical` |
| Split down | `Prefix + H` | Frees default pane-left binding |

## Remaining Prefix Bindings

| Action | Key(s) | Notes |
|---|---|---|
| Help | `Prefix + ?` | |
| Settings | `Prefix + S` | |
| Detach | `Prefix + Q` | Leaves server running |
| Reload config | `Prefix + Shift + R` | |
| Open notification target | `Prefix + O` | |
| Workspace picker | `Prefix + W` | |
| Goto picker | `Prefix + G` | Also has `Ctrl + G` |
| New workspace | `Prefix + Shift + N` | |
| New worktree | `Prefix + Shift + G` | |
| Rename workspace | `Prefix + Shift + W` | Also has `Ctrl + Shift + R` |
| Close workspace | `Prefix + D`, `Prefix + Shift + D` | Also has `Ctrl + Shift + Q` |
| Rename tab | `Prefix + T` | Overrides default `Prefix + Shift + T` |
| Previous tab | `Prefix + P` | |
| Next tab | `Prefix + N` | Also has `Ctrl + Tab` |
| Close tab | `Prefix + Shift + X` | Also has `Ctrl + Q` |
| Rename pane | `Prefix + Shift + P` | |
| Edit scrollback | `Prefix + E` | |
| Move pane focus | `Prefix + J/K/L` | Down/up/right; left is freed for split down |
| Next pane | `Prefix + Tab` | |
| Previous pane | `Prefix + Shift + Tab` | |
| Close pane | `Prefix + X` | |
| Zoom pane | `Prefix + Z` | |
| Resize mode | `Prefix + R` | |
| Toggle sidebar | `Prefix + B` | |
| Copy mode | `Prefix + [` | |

Source: https://herdr.dev/docs/keyboard/
