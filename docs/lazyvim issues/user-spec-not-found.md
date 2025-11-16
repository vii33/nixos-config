# Problem description
When starting LazyVim the error `notify.error lazy.nvim: No specs found for module "user.specs"` appears.

STATUS: ERROR FIXED.

# Further information

## Architecture Analysis vs Official Starter

### Official LazyVim Starter Structure
```
~/.config/nvim/
├── init.lua                    # Bootstraps config.lazy
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # Sets up lazy.nvim & spec imports
│   │   ├── autocmds.lua       # Custom autocommands
│   │   ├── keymaps.lua        # Custom keymaps
│   │   └── options.lua        # Vim options
│   └── plugins/
│       └── example.lua        # Plugin specs (auto-imported)
```

### Our NixVim Hybrid Structure
```
~/.config/nvim/                 # NixVim-generated (read-only)
└── init.lua                    # Generated from lazyvim.nix

~/.config/nvim-local/           # Writable runtime config
└── lua/
    └── user/
        └── specs/
            ├── init.lua        # Aggregates all spec files
            └── keymaps.lua     # Plugin specs (equivalent to plugins/*.lua)
```

### Key Differences & Rationale

1. **No `lua/config/` directory needed**: 
   - NixVim already handles autocmds, keymaps, and options declaratively
   - LazyVim's config files are for users who manage everything with lazy.nvim
   - We only need plugin specs, not the full config structure

2. **`user.specs` instead of `plugins` import**:
   - Official: `{ import = "plugins" }` auto-loads `lua/plugins/*.lua`
   - Ours: `{ import = "user.specs" }` loads `lua/user/specs/init.lua`
   - Why: Clearer separation between NixVim (base) and user runtime additions

3. **init.lua aggregator pattern**:
   - Official: lazy.nvim auto-discovers all files in `plugins/` directory
   - Ours: explicit aggregation via `init.lua` pcall loop
   - Why: More control over load order and easier debugging


## Testing & Diagnostics

### Quick Error Check
Reproduces the actual error during startup:
```bash
nvim --headless +"lua vim.notify = function(msg, level) print(string.format('[LEVEL %s] %s', level or '0', msg)) end" +qall 2>&1
```

Expected output: `[LEVEL 4] No specs found for module "user.specs"`

### Comprehensive Diagnostic
Full diagnostic showing directory checks, file detection, and module loading:
```bash
nvim --headless +"lua vim.schedule(function() print('\\n=== LazyVim Diagnostic ==='); print('nvim-local exists:', vim.fn.isdirectory(vim.fn.expand('~/.config/nvim-local'))); print('user/specs exists:', vim.fn.isdirectory(vim.fn.expand('~/.config/nvim-local/lua/user/specs'))); print('Has .lua files:', vim.fn.glob(vim.fn.expand('~/.config/nvim-local/lua/user/specs/*.lua')) ~= ''); print('\\nAttempting to load user.specs...'); local ok, specs = pcall(require, 'user.specs'); print('Load success:', ok); if ok then print('Specs count:', #specs); print('Specs:', vim.inspect(specs)) else print('Error:', specs) end; vim.cmd('qall!') end)" 2>&1
```

### Verify Runtime Path
Check if nvim-local is properly added to runtime path:
```bash
nvim --headless +"lua print('RTP before prepend:'); for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do if path:match('nvim') then print('  ' .. path) end end; vim.opt.rtp:prepend(vim.fn.expand('~/.config/nvim-local')); print('\\nRTP after prepend:'); for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do if path:match('nvim') then print('  ' .. path) end end; print('\\nCan require user.specs?', pcall(require, 'user.specs'))" +qall 2>&1
```

### Manual Spec Loading Test
Verify specs load correctly when runtime path is manually set (this should work):
```bash
nvim --headless +"lua vim.opt.rtp:prepend(vim.fn.expand('~/.config/nvim-local')); local specs = require('user.specs'); print('Total specs:', #specs)" +qall
```

## Root Cause Analysis

The error occurred because **`vim.fn.glob()` returns an empty string** during the initialization phase in `lazyvim.nix`, even when `.lua` files exist. This is a timing issue where:

1. The check `vim.fn.glob(user_specs_path .. "/*.lua") ~= ""` evaluates to `false`
2. Therefore, `{ import = "user.specs" }` is never added to the specs table
3. The runtime path IS correctly prepended, but lazy.nvim never attempts to import user.specs
4. When manually testing with `vim.opt.rtp:prepend()` followed by `require()`, it works fine

The issue is not with the runtime path or module structure, but with the file detection logic using `vim.fn.glob()`.

## Solution

Instead of using lazy.nvim's `{ import = "user.specs" }` mechanism (which has its own module loader), we directly `require()` the user specs and insert them into the specs table:

```lua
-- Load user specs directly instead of using lazy's import
local ok, user_specs = pcall(require, "user.specs")
if ok and user_specs then
  for _, spec in ipairs(user_specs) do
    table.insert(specs, spec)
  end
end
```

This approach:
- Uses Lua's standard `require()` which respects `package.path`
- Works immediately after setting `package.path`
- Avoids lazy.nvim's import mechanism which may have timing or caching issues
- Gracefully handles missing or empty specs with pcall