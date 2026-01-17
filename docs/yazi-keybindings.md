# Yazi Terminal File Explorer

Yazi is a blazing-fast terminal file manager written in Rust, featuring async I/O and a modern UI.

## Starting Yazi

```fish
yazi          # Open in current directory
yazi ~/path   # Open in specific directory
```

## Navigation

### Basic Movement
- `j` / `↓` — Move cursor down
- `k` / `↑` — Move cursor up
- `h` / `←` — Go to parent directory
- `l` / `→` — Enter directory / open file
- `g` — Jump commands:
  - `gg` — Jump to top
  - `G` — Jump to bottom
- `f` — Filter files (type to filter, `Esc` to clear)
- `F` — Find files (search and jump)

### Quick Navigation
- `~` — Go to home directory
- `/` — Go to root directory
- `.` — Toggle hidden files
- `z` — Jump to a directory (uses zoxide)

## File Operations

### Selection
- `Space` — Toggle selection for current file
- `v` — Enter visual mode (select multiple files)
- `V` — Enter visual mode (unset selection)
- `Ctrl-a` — Select all files
- `Ctrl-r` — Reverse selection

### Copy, Cut, Paste
- `y` — Yank (copy) selected files
- `x` / `d` — Cut selected files
- `p` — Paste files
- `P` — Paste files (overwrite)
- `Shift-y` — Yank file path

### File Management
- `o` — Open file with default application
- `O` — Open file interactively (choose application)
- `r` — Rename file
- `c` — Create:
  - Then type filename and press `Enter`
- `Delete` / `Shift-d` — Move to trash
- `Shift-D` — Permanently delete

### Archive Operations
- `e` — Extract archive
- `c` — Compress selection

## Tabs and Panes

### Tabs
- `t` — Create new tab
- `w` — Close current tab
- `Tab` / `Shift-Tab` — Switch between tabs
- `1-9` — Switch to tab N

### Dual Pane
- `Ctrl-n` — Create dual pane
- `Ctrl-w` — Close pane
- `Ctrl-h/j/k/l` — Navigate between panes

## Preview

- Yazi shows file previews in the right panel automatically
- Supports:
  - Text files
  - Images (if terminal supports)
  - Archives
  - PDFs (with external tools)
  - Markdown
  - Code with syntax highlighting

## Search and Filtering

### Filter
- `f` — Filter files in current directory
  - Type to filter
  - `Esc` to clear filter

### Find
- `F` — Find and jump to file
  - Type to search
  - `Enter` to jump
  - `Esc` to cancel

### Grep Search
- `/` — Search file contents (if configured)

## Shell Integration

### Quick Exit to Directory
To change your shell's working directory when exiting Yazi, use the wrapper function in your Fish config:

```fish
function ya
    set tmp (mktemp -t "yazi-cwd.XXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
```

Then use `ya` instead of `yazi` to automatically cd to the directory when you quit.

## Bookmarks

- `m` — Create bookmark
  - `m<key>` — Create bookmark with key (e.g., `ma`, `mb`)
- `'` — Jump to bookmark
  - `'<key>` — Jump to bookmark (e.g., `'a`, `'b`)

## Help and Configuration

- `F1` — Show help
- `q` — Quit yazi
- `Q` — Quit all tabs

## Useful Combinations

### Bulk Rename
1. Select files with `Space` or `v` (visual mode)
2. Press `r` to rename
3. Edit in your editor
4. Save and close to apply changes

### Copy File Path
- `Shift-y` — Copy current file path to clipboard
- Useful for pasting paths in terminal commands

### Open in External Editor
- `o` — Open with default editor (usually `$EDITOR`)
- `O` — Choose application to open with

## Configuration Location

Yazi configuration files are located at:
- `~/.config/yazi/yazi.toml` — Main configuration
- `~/.config/yazi/keymap.toml` — Custom keybindings
- `~/.config/yazi/theme.toml` — Color theme

## Tips

1. **Performance**: Yazi is async and won't freeze on large directories
2. **Image Preview**: Works best in terminals with image support (Kitty, WezTerm, etc.)
3. **Integration**: Works seamlessly with `zoxide`, `fzf`, and `ripgrep`
4. **Plugins**: Yazi supports Lua plugins for extended functionality
5. **Mouse Support**: You can click to navigate (if terminal supports mouse)

## Common Workflows

### Quick File Finding
1. `F` to open find
2. Type filename
3. `Enter` to jump to file
4. `l` to open it

### Organize Files
1. `v` to enter visual mode
2. `j/k` to select files
3. `x` to cut or `y` to copy
4. `h` to go to parent, `l` to enter destination
5. `p` to paste

### View Large Directory
1. `f` to filter
2. Type pattern
3. Navigate filtered results
4. `Esc` to clear and see all files again

## See Also

- [Yazi Official Documentation](https://yazi-rs.github.io/)
- [Neovim Shortcuts](neovim-shortcuts.md)
- [Fish Shell Shortcuts](shortcuts.md)
