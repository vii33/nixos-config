# modules/home/yazi.nix
# Yazi terminal file manager configuration
{ config, pkgs, inputs, ... }:

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
    # Default text editor
    edit = [
      { run = '$EDITOR "$@"', block = true, desc = "Edit in $EDITOR" },
    ]
    
    [open]   # Wiring of openers to mime types
    # Prepend our custom rules but keep defaults for images, videos, etc.
    prepend_rules = [
      { mime = "text/*", use = ["code", "edit"] },
      { mime = "application/json", use = ["code", "edit"] },
      { mime = "application/javascript", use = ["code", "edit"] },
      { name = "*.yaml", use = ["code", "edit"] },
      { name = "*.yml", use = ["code", "edit"] },
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
      { mime = "text/x-python", fg = "#7FB4CA" },
      { mime = "text/javascript", fg = "#7FB4CA" },
      { mime = "text/x-rust", fg = "#7FB4CA" },
      { name = "*.ipynb", fg = "#7FB4CA" },
      { name = "*.nix", fg = "#7FB4CA" },
      { name = "*.ts", fg = "#7FB4CA" },
      { name = "*.tsx", fg = "#7FB4CA" },
      { name = "*.jsx", fg = "#7FB4CA" },
      
      # Config files - Yellow
      { name = "*.json", fg = "#FFA066" },
      { name = "*.toml", fg = "#FFA066" },
      { name = "*.yaml", fg = "#FFA066" },
      { name = "*.yml", fg = "#FFA066" },
      
      # Images - Magenta
      { mime = "image/*", fg = "#9c81c6" },
      
      # Videos - Magenta (darker)
      { mime = "video/*", fg = "#8666b8" },
      
      # Archives - Green
      { mime = "application/zip", fg = "#98BB6C" },
      { mime = "application/x-tar", fg = "#98BB6C" },
      { name = "*.rar", fg = "#98BB6C" },
      { name = "*.7z", fg = "#98BB6C" },
      
      # Documents - Cyan
      { mime = "application/pdf", fg = "#7AA89F" },
      { name = "*.md", fg = "#7AA89F" },
      { name = "*.doc*", fg = "#7AA89F" },
      { name = "*.xls*", fg = "#7AA89F" },
      
      # Executables - Red
      { name = "*.sh", fg = "#E46876" },
      { name = "*.fish", fg = "#E46876" },
    ]
  '';
  
  # Custom keybindings
  home.file.".config/yazi/keymap.toml".text = ''
    [mgr]
    prepend_keymap = [   # Higher priority than default keymap
      { on = [ "z" ], run = "plugin zoxide", desc = "Jump to a directory using zoxide" },
      { on = [ "Z" ], run = "plugin fzf", desc = "Jump to a directory or reveal a file using fzf" },
      
      # Quick Look with space bar, Tab for selection, = for peek/properties
      { on = [ "<Space>" ], run = "shell 'qlmanage -p \"$0\" > /dev/null 2>&1' --orphan", desc = "Preview with Quick Look (macOS)" },
      { on = [ "<Tab>" ], run = "toggle", desc = "Toggle selection" },
      { on = [ "=" ], run = "peek", desc = "Peek (show properties)" },
      
      # Custom "g" shortcuts for quick directory access
      { on = [ "g", "r" ], run = 'cd "~/repos"', desc = "Go to repos" },
      { on = [ "g", "a" ], run = 'cd "~/OneDrive - BMW Group/_FG-464 Gruppe/ADPnext"', desc = "Go to ADP.next" },
      { on = [ "g", "o" ], run = 'cd "~/OneDrive - BMW Group"', desc = "Go to OneDrive" },
      { on = [ "g", "D" ], run = 'cd "~/Documents"', desc = "Go to Documents" },    
      { on = [ "g", "s" ], run = 'cd "~/Documents/Screenshots"', desc = "Go to Screenshots" },
      { on = [ "g", "d" ], run = 'cd "~/Downloads"', desc = "Go to Downloads" }, 
      { on = [ "g", "p" ], run = 'cd "~/OneDrive - BMW Group/Capgemini/Capgemini POs"', desc = "Go to Capgemini POs" },     
    ]
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
  '';
}
