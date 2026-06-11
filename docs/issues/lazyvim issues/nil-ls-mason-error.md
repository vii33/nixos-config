# LazyVim / Mason `nil_ls` Error

## Symptoms

When opening a file in Neovim (LazyVim + NixVim hybrid setup), the following error appeared:

> `notify.error mason-lspconfig.nvim [mason-lspconfig.nvim] failed to install nil_ls`

` :MasonLog` showed:

> `Installation failed for Package(name=nil) error=spawn: cargo failed with exit code - and signal -. Could not find executable "cargo" in PATH.`

## Root Cause

- LazyVim's LSP integration was configured (by default) to use `mason-lspconfig.nvim` to **auto-install** certain language servers.
- For Nix, it tried to install the **`nil` language server** (LSP name: `nil_ls`).
- `nil` is written in Rust and built using `cargo`.
- In this NixOS environment, `cargo` was **not** available in `$PATH`, so Mason could not build `nil` and the install failed.
- This is **not** a dynamic linking problem; it's purely a missing Rust toolchain for Mason's build step.

## Desired Architecture

In this repository, the chosen architecture is:

- **Nix** (NixOS/Home Manager/flake) manages **all LSP binaries** (including Nix language servers).
- **LazyVim + lazy.nvim** manage plugins, UI, and editor behavior, but **do not download or build LSP executables**.

This avoids duplication between Mason and Nix, and keeps LSP versions declarative and reproducible.

## Changes in `modules/home/nixvim/lazyvim.nix`

We ensure LSP servers (including Nix) are configured via NixVim:

```nix
programs.nixvim = {
  enable = true;
  vimAlias = true;

  lsp = {
    servers = {
      bashls.enable   = true;
      dockerls.enable = true;
      html.enable     = true;
      jsonls.enable   = true;
      lua_ls.enable   = true;
      nixd.enable     = true;  # Nix LSP, managed by Nix
    };
  };

  # Enable lazy.nvim plugin manager
  plugins.lazy.enable = true;

  extraConfigLua = ''
    -- Leader
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Writable runtime path for user specs
    local devdir = vim.fn.expand("~/.config/nvim-local")
    if vim.fn.isdirectory(devdir) == 0 then
      vim.fn.mkdir(devdir .. "/lua/user/specs", "p")
    end
    vim.opt.rtp:prepend(devdir)

    -- LazyVim bootstrap
    local specs = {
      { "LazyVim/LazyVim", import = "lazyvim.plugins" },
      { import = "lazyvim.plugins.extras.lang.python" },
    }

    local user_specs_path = vim.fn.expand("~/.config/nvim-local/lua/user/specs")
    if vim.fn.isdirectory(user_specs_path) == 1 then
      local has_files = vim.fn.glob(user_specs_path .. "/*.lua") ~= ""
      if has_files then
        table.insert(specs, { import = "user.specs" })
      end
    end

    require("lazy").setup({
      spec = specs,
      defaults = { lazy = false, version = false },
      change_detection = { notify = false },
      checker = { enabled = false },
    })
  '';
};
```

Result: `:LspInfo` shows `nixd` as the active Nix LSP (provided by Nix), not `nil_ls`.

## Disabling Mason's Automatic LSP Installation (Option A)

To prevent Mason from trying to auto-install any language servers (including `nil_ls`), we added a user spec in the writable `nvim-local` directory.

### 1. Mason override spec

File: `~/.config/nvim-local/lua/user/specs/mason-local.lua`

```lua
return {
  -- Override LazyVim's Mason LSP behavior: Nix manages LSP binaries
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Do NOT auto-install any LSP servers; they come from Nix
      ensure_installed = {},
      automatic_installation = false,
    },
  },
}
```

### 2. Aggregating user specs

File: `~/.config/nvim-local/lua/user/specs/init.lua`

```lua
-- Aggregate user specs for LazyVim from this writable directory
-- This file is read via { import = "user.specs" } in the NixVim bootstrap.

local M = {}

local specs = {
  "mason-local",
}

for _, mod in ipairs(specs) do
  local ok, spec = pcall(require, "user.specs." .. mod)
  if ok and type(spec) == "table" then
    for _, s in ipairs(spec) do
      table.insert(M, s)
    end
  end
end

return M
```

The Nix-side bootstrap in `lazyvim.nix` already does:

```lua
local user_specs_path = vim.fn.expand("~/.config/nvim-local/lua/user/specs")
if vim.fn.isdirectory(user_specs_path) == 1 then
  local has_files = vim.fn.glob(user_specs_path .. "/*.lua") ~= ""
  if has_files then
    table.insert(specs, { import = "user.specs" })
  end
end
```

This ensures `user.specs` (and therefore `mason-local`) is imported by LazyVim.

## Outcome

- Mason remains installed and usable (`:Mason`, `:MasonLog`).
- Mason **no longer auto-installs language servers**, including `nil_ls`.
- The error
  - `failed to install nil_ls`
  - `Could not find executable "cargo" in PATH.`
  no longer appears.
- All LSP binaries (including `nixd`) are managed declaratively through Nix/NixOS configs, while LazyVim handles plugins and editor behavior.

## Quick Verification

1. Open a Nix file and run:

   ```vim
   :LspInfo
   ```

   - `nixd` should be listed as the attached client.

2. Run:

   ```vim
   :Mason
   ```

   - No new errors about `nil`/`nil_ls` should appear.

3. Check logs (optional):

   ```vim
   :MasonLog
   ```

   - There should be no recent attempts to install `nil` using `cargo`.
