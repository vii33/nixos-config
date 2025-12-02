## Neovim/LazyVim Shortcuts

Back to the main shortcuts list: see [docs/shortcuts.md](docs/shortcuts.md).

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
