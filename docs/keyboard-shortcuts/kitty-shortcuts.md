# Kitty Terminal Shortcuts

These keyboard shortcuts are configured in `modules/home/kitty.nix`.

## Tab Management

| Key | Action |
|---|---|
| `Ctrl + Shift + T` | new tab |
| `Ctrl + Shift + Q` | close tab |
| `Ctrl + Shift + H` | previous tab |
| `Ctrl + Shift + L` | next tab |
| `Ctrl + Shift + 1-5` | jump to tab 1-5 |

> Note: `Alt + ...` is intentionally left unbound in Kitty so Zellij can use it (e.g. `Alt + 1-5`).

## Window Management

| Key | Action |
|---|---|
| `Ctrl + Shift + Enter` | new window in current working directory |
| `Ctrl + Shift + W` | close window |

## Window Navigation

| Key | Action |
|---|---|
| `Ctrl + Shift + Ä` | next window |
| `Ctrl + Shift + Ö` | previous window |
| `Ctrl + Shift + J` | neighboring window down |
| `Ctrl + Shift + K` | neighboring window up |

## Copy & Paste

| Key | Action |
|---|---|
| `Ctrl + C` | copy or interrupt |
| `Ctrl + V` | paste from clipboard |

## Font Size

| Key | Action |
|---|---|
| `Ctrl + Shift + +` | increase font size by 1.0 |
| `Ctrl + Shift + -` | decrease font size by 1.0 |
| `Ctrl + Shift + 0` | reset font size to default |

## FZF (Fuzzy Finder) Shortcuts

These shortcuts work when inside an FZF search list. Configured via `FZF_DEFAULT_OPTS` in `modules/home/fish-shell.nix`.

| Key | Action | Notes |
|---|---|---|
| `Ctrl + J` | move down one item | Only inside fzf |
| `Ctrl + K` | move up one item | Only inside fzf |
| `Ctrl + U` | half-page up | Only inside fzf |
| `Ctrl + D` | half-page down | Only inside fzf |
| `Enter` | accept selection | Only inside fzf |
