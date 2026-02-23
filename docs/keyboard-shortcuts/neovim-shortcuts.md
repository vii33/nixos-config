## Neovim/LazyVim Shortcuts

Back to the main shortcuts list: see [docs/shortcuts.md](../shortcuts.md).

### Basic Vim Commands

Text objects with `a` (around) and `i` (inside) - use with operators like `d`, `c`, `y`, `v`:

| Text Object | Description |
|-------------|-------------|
| `iq` / `aq` | Inside/around quotes (auto-detects `"`, `'`, `` ` ``) |
| `ib` / `ab` | Inside/around brackets (auto-detects `()`, `[]`, `{}`) |
| `if` / `af` | Inside/around function call |
| `ia` / `aa` | Inside/around function argument |
| `it` / `at` | Inside/around HTML/XML tags |

Examples: `daf` (delete around function), `cia` (change inside argument), `viq` (select inside quotes)

### Scrolling & Cursor Positioning

| Key | Action | Notes |
|---|---|---|
| `Ctrl + d` | Scroll half-screen down | "d" mnemonic = down; cursor stays at same window-relative row — document moves down by half a screen |
| `Ctrl + u` | Scroll half-screen up | "u" mnemonic = up; cursor stays at same window-relative row — document moves up by half a screen |
| `Ctrl + f` | Scroll forward by a full page | "f" = forward/page down; can be prefixed with a count (e.g. `5<Ctrl+f>` to move 5 pages) |
| `Ctrl + b` | Scroll backward by a full page | "b" = backward/page up; can be prefixed with a count (e.g. `3<Ctrl+b>` to move 3 pages) |
| `zt` | Move current line to top of window | Leaves a few lines of context below the cursor when possible |
| `zb` | Move current line to bottom of window | Leaves a few lines of context above the cursor when possible |
| `zz` | Move current line to center/middle of window | Handy for keeping focus while navigating |

You can find other scrolling keybindings in the Neovim documentation by running `:help scrolling`.

### Increment / Decrement Numbers

| Key | Action | Notes |
|---|---|---|
| `Ctrl + a` | Increment the number under the cursor | "Add" mnemonic; accepts counts (e.g. `5<C-a>` to add 5) |
| `Ctrl + x` | Decrement the number under the cursor | "Cross out" mnemonic; accepts counts (e.g. `3<C-x>` to subtract 3) |

### Outline

| Key | Action | Notes |
|---|---|---|
| `Space + c + s` | Toggle Outline | `<leader>cs` - Shows code symbols/structure |

### Harpoon2

These keyboard shortcuts are configured in `modules/home/nixvim/lua-specs/harpoon2.lua`.

| Key | Action | Notes |
|---|---|---|
| `Space + H` | Add file to Harpoon list | `<leader>H` |
| `Space + h` | Toggle Harpoon quick menu | `<leader>h` |
| `Space + 1` | Jump to Harpoon file 1..9 | `<leader>1` |

### Buffers

| Key | Action | Notes |
|---|---|---|
| `Shift + l` | Next Buffer | |
| `Shift + h` | Previous Buffer | |
| `Space + ,` | Show Open Buffers | i.e. `<leader>,` |
| `<leader> bd` | Close Current Buffer | Buffer Delete |
| `<leader> bo` | Close All Other Buffers | Buffer Other |

### Commenting (gc)

The `gc` verb toggles comments and can be combined with motions, counts, text objects or visual selections.

| Command | Action | Examples/Notes |
|---|---|---|
| `gc` + motion/text-object | Toggle comment for the motion or text object | `gc5j` comments the current line and the five lines below; `gcap` comments a paragraph (`a` = around, `p` = paragraph) |
| `gcc` | Toggle comment for current line | `5gcc` comments five lines (a shorthand alternative to `gc4j`) |
| `gc` in visual mode | Toggle comment for the selection | e.g. `V5jgc` comments a 6-line visual selection |
| `gcO` / `gco` | Insert a new commented line above (`gcO`) or below (`gco`) the current line | Handy for adding a comment line without commenting the current line |
| `gc` is a toggle | If a line is already commented it will be uncommented | Works across the supported comment styles for the filetype |

This pairs nicely with the surrounding operator `S` — for example, after invoking `S` you can use `gcSh` to comment the function surrounded by the `h` labels.
