# modules/home/yazi.nix
# Yazi terminal file manager configuration
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  directoryOpeners =
    if isDarwin then
      ''["default-app", "reveal-finder", "code-dir", "cd-dir", "cd-dir-and-quit"]''
    else
      ''["code-dir", "cd-dir", "cd-dir-and-quit"]'';
  textOpeners =
    if isDarwin then
      ''["code", "default-app", "reveal-finder", "code-folder", "edit"]''
    else
      ''["code", "code-folder", "edit"]'';
  mediaOpeners =
    if isDarwin then
      ''["default-app", "reveal-finder", "code-folder"]''
    else
      ''["open", "code-folder", "reveal"]'';
  playableOpeners =
    if isDarwin then
      ''["play", "default-app", "reveal-finder", "code-folder"]''
    else
      ''["play", "code-folder", "reveal"]'';
  archiveOpeners =
    if isDarwin then
      ''["extract", "default-app", "reveal-finder", "code-folder"]''
    else
      ''["extract", "code-folder", "reveal"]'';
  defaultOpeners =
    if isDarwin then
      ''["default-app", "reveal-finder", "code-folder"]''
    else
      ''["open", "code-folder", "reveal"]'';
in
{
  # Install yazi package
  home.packages = with pkgs; [
    yazi
    #poppler_utils      # PDF previews (pdftoppm)
  ];

  # Install the Kanagawa flavor declaratively
  home.file.".config/yazi/flavors/kanagawa.yazi" = {
    source = inputs.kanagawa-yazi;
  };

  # Configure Yazi settings
  home.file.".config/yazi/yazi.toml".text = ''
    [mgr]
    ratio = [ 2, 5, 3 ]   # Ratio of the 3 panes 
    linemode = "mtime"    # Show modified time with custom format (see init.lua below)
    use_trash = true      # Move deleted files to macOS Trash instead of permanent delete
    show_hidden = true    # Show and search hidden files (dotfiles)
    sort_by = "natural"
    sort_sensitive = false
    sort_reverse = false
    sort_dir_first = true

    [preview]
    tab_size = 2
    max_width = 600
    max_height = 900

    [opener]  # Programs to open files with specific mime types
    # VS Code opener
    code = [
      { run = 'open -a "Visual Studio Code" "$@"', desc = "Open in VS Code", orphan = true },
    ]
    code-folder = [
      { run = 'open -a "Visual Studio Code" %d1', desc = "Open containing folder in VS Code", orphan = true },
    ]
    # VS Code opener for directories (passes the directory itself, not its parent)
    code-dir = [
      { run = 'open -a "Visual Studio Code" "$@"', desc = "Open Folder with VS Code", orphan = true },
    ]
    # Change Yazi's CWD to the selected directory. If Yazi was launched through a
    # --cwd-file wrapper, quitting with `q` will then cd the parent shell there.
    cd-dir = [
      { run = 'ya emit cd %s1', desc = "Open folder in shell" },
    ]
    cd-dir-and-quit = [
      { run = 'ya emit cd %s1; ya emit quit', desc = "Open folder in shell and quit" },
    ]
    # Default text editor
    edit = [
      { run = '$EDITOR "$@"', block = true, desc = "Edit in $EDITOR" },
    ]
    ${lib.optionalString isDarwin ''
      default-app = [
        { run = 'open "$@"', desc = "Open in default app", orphan = true },
      ]
      reveal-finder = [
        { run = 'open -R "$@"', desc = "Reveal in Finder", orphan = true },
      ]
    ''}

    [open]   # Wiring of openers to mime types
    # Replace the defaults so directory entries don't also inherit Yazi's default
    # editor/open/reveal actions, which caused duplicate VS Code choices.
    rules = [
      # Directories — only folder-specific actions
      { url = "*/", use = ${directoryOpeners} },
      # Code / text files — VS Code as primary, plus containing folder & editor
      { mime = "text/*", use = ${textOpeners} },
      { mime = "application/json", use = ${textOpeners} },
      { mime = "application/ndjson", use = ${textOpeners} },
      { mime = "application/javascript", use = ${textOpeners} },
      { url = "*.yaml", use = ${textOpeners} },
      { url = "*.yml", use = ${textOpeners} },
      # Media and archives keep their native defaults where useful.
      { mime = "image/*", use = ${mediaOpeners} },
      { mime = "{audio,video}/*", use = ${playableOpeners} },
      { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", use = ${archiveOpeners} },
      { mime = "inode/empty", use = ${textOpeners} },
      { mime = "vfs/{absent,stale}", use = "download" },
      # All other files — system open first, but always offer the containing folder in VS Code.
      { url = "*", use = ${defaultOpeners} },
    ]
  '';

  # Configure Yazi to use the Kanagawa theme
  home.file.".config/yazi/theme.toml".text = ''
    [flavor]
    dark = "kanagawa"

    # Custom file type colors
    [filetype]
    rules = [
      # Code files - Blue
      { mime = "text/x-python", fg = "#8CCFE0" },
      { mime = "text/javascript", fg = "#8CCFE0" },
      { mime = "text/x-rust", fg = "#8CCFE0" },
      { url = "*.ipynb", fg = "#8CCFE0" },
      { url = "*.nix", fg = "#8CCFE0" },
      { url = "*.ts", fg = "#8CCFE0" },
      { url = "*.tsx", fg = "#8CCFE0" },
      { url = "*.jsx", fg = "#8CCFE0" },
      
      # Config files - Yellow
      { url = "*.json", fg = "#FFA066" },
      { url = "*.toml", fg = "#FFA066" },
      { url = "*.yaml", fg = "#FFA066" },
      { url = "*.yml", fg = "#FFA066" },
      
      # Images - Magenta
      { mime = "image/*", fg = "#B19BF0" },
       
      # Videos - Magenta (darker)
      { mime = "video/*", fg = "#9C82D8" },
       
      # Archives - Green
      { mime = "application/zip", fg = "#AEDA78" },
      { mime = "application/x-tar", fg = "#AEDA78" },
      { url = "*.rar", fg = "#AEDA78" },
      { url = "*.7z", fg = "#AEDA78" },
       
      # Documents - Cyan
      { mime = "application/pdf", fg = "#8FD6C5" },
      { url = "*.md", fg = "#8FD6C5" },
      { url = "*.doc*", fg = "#8FD6C5" },
      { url = "*.xls*", fg = "#8FD6C5" },
       
      # Executables - Red
      { url = "*.sh", fg = "#F27E89" },
      { url = "*.fish", fg = "#F27E89" },
    ]
  '';

  # Custom keybindings
  home.file.".config/yazi/keymap.toml".text = ''
    [mgr]
    prepend_keymap = [   # Higher priority than default keymap
      # Smart enter: enter directories, open files (see https://yazi-rs.github.io/docs/tips/)
      { on = [ "<Enter>" ], run = "plugin smart-enter", desc = "Enter directory / open file" },

      # On macOS, `O` reveals in Finder; Linux keeps the default opener.
      { on = [ "o" ], run = "open --interactive", desc = "Open with..." },
      { on = [ "O" ], run = "${if isDarwin then "shell --orphan -- open -R %s" else "open"}", desc = "${
        if isDarwin then "Reveal in Finder" else "Open"
      }" },
      { on = [ "z" ], run = "plugin zoxide", desc = "Jump to a directory using zoxide" },
      { on = [ "Z" ], run = "plugin fzf", desc = "Jump to a directory or reveal a file using fzf" },
      
      # Quick Look with space bar, Tab for selection, = for peek/properties
      { on = [ "<Space>" ], run = "shell 'qlmanage -p \"$0\" > /dev/null 2>&1' --orphan", desc = "Preview with Quick Look (macOS)" },
      { on = [ "<Tab>" ], run = "toggle", desc = "Toggle selection" },
      { on = [ "+" ], run = "peek", desc = "Peek (show properties)" },

      # Sorting tweaks: use lowercase `m` for reverse mtime sort.
      { on = [ ",", "m" ], run = [ "sort mtime --reverse=yes", "linemode mtime" ], desc = "Sort by modified time (reverse)" },
      { on = [ ",", "M" ], run = [ "sort mtime --reverse=no", "linemode mtime" ], desc = "Sort by modified time" },
      
      # Copy file to macOS clipboard (paste in Finder, Outlook, etc.)
      { on = [ "Y" ], run = "shell 'osascript -e \"on run argv\" -e \"set the clipboard to {((POSIX file (item 1 of argv)) as alias)}\" -e \"end run\" -- \"$0\"' --confirm", desc = "Copy file to macOS clipboard" },

      # Custom "g" shortcuts for quick directory access
      { on = [ "g", "r" ], run = 'cd "~/repos"', desc = "Go to repos" },
      { on = [ "g", "a" ], run = 'cd "~/repos/awesome-agents"', desc = "Go to awesome-agents" },
      { on = [ "g", "o" ], run = 'cd "~/OneDrive - BMW Group"', desc = "Go to OneDrive" },
      { on = [ "g", "D" ], run = 'cd "~/Documents"', desc = "Go to Documents" },    
      { on = [ "g", "s" ], run = 'cd "~/Documents/Screenshots"', desc = "Go to Screenshots" },
      { on = [ "g", "d" ], run = 'cd "~/Downloads"', desc = "Go to Downloads" }, 
    ]
  '';

  # Plugins
  home.file.".config/yazi/plugins/smart-enter.yazi/main.lua".text = ''
    --- @since 25.5.31
    --- @sync entry

    local function setup(self, opts) self.open_multi = opts.open_multi end

    local function entry(self)
    	local h = cx.active.current.hovered
    	ya.emit(h and h.cha.is_dir and "enter" or "open", { hovered = not self.open_multi })
    end

    return { entry = entry, setup = setup }
  '';

  # Custom linemode with MM-DD HH:MM for recent files, YYYY-MM-DD for older
  home.file.".config/yazi/init.lua".text = ''
    -- Custom date formatting function
    function strip_date_year(time_to_format)
      local time = math.floor(time_to_format or 0)
      if time == 0 then
        return ""
      elseif os.date("%Y", time) == os.date("%Y") then
        return os.date("%m-%d %H:%M", time)
      else
        return os.date("%Y-%m-%d", time)
      end
    end

    -- Override mtime linemode
    function Linemode:mtime()
      return strip_date_year(self._file.cha.mtime)
    end

    -- Override btime linemode (birth time)
    function Linemode:btime()
      return strip_date_year(self._file.cha.btime)
    end

    -- Preserve default "open selected" behavior when multiple entries are selected.
    require("smart-enter"):setup { open_multi = true }
  '';
}
