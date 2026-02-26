# Yazi Terminal File Explorer

Yazi is a blazing-fast terminal file manager written in Rust, featuring async I/O and a modern UI.

**Official Documentation:** https://yazi-rs.github.io/docs/quick-start/

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
- `K` — Seek up 5 units in the preview
- `J` — Seek down 5 units in the preview
- `g` then `g` — Jump to top
- `G` — Jump to bottom

### Quick Navigation
- `z` — Cd to a directory via zoxide
- `Z` — Cd to a directory or reveal a file via fzf
- `g` then `Space` — Cd to a directory or reveal a file via interactive prompt
- `.` — Toggle hidden files

### Custom `g` Shortcuts (nixos-config)
- `g` then `r` — Go to `~/repos`
- `g` then `a` — Go to ADP.next (OneDrive)
- `g` then `o` — Go to OneDrive
- `g` then `D` — Go to `~/Documents`
- `g` then `s` — Go to `~/Documents/Screenshots`
- `g` then `d` — Go to `~/Downloads`
- `g` then `p` — Go to Capgemini POs (OneDrive)

## File Operations

### Selection
- `Space` — Toggle selection for current file
- `v` — Enter visual mode (selection mode)
- `V` — Enter visual mode (unset mode)
- `Ctrl+a` — Select all files
- `Ctrl+r` — Inverse selection of all files
- `Esc` — Cancel selection

### Copy, Cut, Paste
- `y` — Yank (copy) selected files
- `x` — Yank (cut) selected files
- `p` — Paste into hovered directory or CWD (smart-paste)
- `P` — Paste files (overwrite)
- `Y` or `X` — Cancel the yank status

### File Management
- `o` — Open file interactively (choose application)
- `O` — Open file with default application
- `Enter` — Enter directory / open file (smart-enter)
- `Shift+Enter` — Open selected files interactively (some terminals don't support)
- `Tab` — Show file information
- `r` — Rename file
- `a` — Create file (has to end with ´/´ for directories)
- `d` — Trash selected files
- `D` — Permanently delete selected files
- `;` — Run a shell command
- `:` — Run a shell command (block until finishes)

### Copy Paths
- `c` then `c` — Copy the file path
- `c` then `d` — Copy the directory path
- `c` then `f` — Copy the filename
- `c` then `n` — Copy the filename without extension


## Tabs and Panes

### Tabs
- `t` — Create new tab with CWD
- `1-9` — Switch to the N-th tab
- `[` — Switch to the previous tab
- `]` — Switch to the next tab
- `{` — Swap current tab with previous tab
- `}` — Swap current tab with next tab
- `Ctrl+c` — Close the current tab

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

### Filter Files
- `f` — Filter files in current directory
  - Type to filter
  - `Esc` to clear filter

### Find Files
- `/` — Find next file
- `?` — Find previous file
- `n` — Go to the next found
- `N` — Go to the previous found

### Search Files
- `s` — Search files by name using fd
- `S` — Search files by content using ripgrep
- `Ctrl+s` — Cancel the ongoing search

### Sorting
Press `,` (comma) followed by:
- `m` — Sort by modified time
- `b` — Sort by birth time
- `e` — Sort by file extension
- `a` — Sort alphabetically
- `n` — Sort naturally
- `s` — Sort by size
- `r` — Sort randomly

Use capital letters (e.g., `M`, `B`, `E`) for reverse sorting.

### Line Mode (Display Info)
- `M` (Shift+m) — Cycle through line modes:
  - `size` — Show file sizes
  - `mtime` — Show modification time
  - `permissions` — Show file permissions
  - `none` — Filename only

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

- `F1` or `~` — Show help
- `q` — Quit yazi
- `Q` — Quit all tabs (without changing directory)

## Useful Combinations

### Bulk Rename
1. Select files with `Space` or `v` (visual mode)
2. Press `r` to rename
3. Edit in your editor
4. Save and close to apply changes

### Copy File Path
- `c` then `c` — Copy current file path to clipboard
- `c` then `d` — Copy directory path
- `c` then `f` — Copy filename
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
1. `s` to search files by name (uses fd)
2. Type filename pattern
3. Navigate results with arrow keys or `j/k`
4. `Enter` to jump to selected file
5. `l` to open it

### Quick Content Search
1. `S` to search file contents (uses ripgrep)
2. Type search pattern
3. Navigate matches
4. `Enter` to jump to file

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
