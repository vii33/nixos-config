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
      { mime = "text/x-python", fg = "#8CCFE0" },
      { mime = "text/javascript", fg = "#8CCFE0" },
      { mime = "text/x-rust", fg = "#8CCFE0" },
      { name = "*.ipynb", fg = "#8CCFE0" },
      { name = "*.nix", fg = "#8CCFE0" },
      { name = "*.ts", fg = "#8CCFE0" },
      { name = "*.tsx", fg = "#8CCFE0" },
      { name = "*.jsx", fg = "#8CCFE0" },
      
      # Config files - Yellow
      { name = "*.json", fg = "#FFA066" },
      { name = "*.toml", fg = "#FFA066" },
      { name = "*.yaml", fg = "#FFA066" },
      { name = "*.yml", fg = "#FFA066" },
      
      # Images - Magenta
      { mime = "image/*", fg = "#B19BF0" },
       
      # Videos - Magenta (darker)
      { mime = "video/*", fg = "#9C82D8" },
       
      # Archives - Green
      { mime = "application/zip", fg = "#AEDA78" },
      { mime = "application/x-tar", fg = "#AEDA78" },
      { name = "*.rar", fg = "#AEDA78" },
      { name = "*.7z", fg = "#AEDA78" },
       
      # Documents - Cyan
      { mime = "application/pdf", fg = "#8FD6C5" },
      { name = "*.md", fg = "#8FD6C5" },
      { name = "*.doc*", fg = "#8FD6C5" },
      { name = "*.xls*", fg = "#8FD6C5" },
       
      # Executables - Red
      { name = "*.sh", fg = "#F27E89" },
      { name = "*.fish", fg = "#F27E89" },
    ]
  '';
  
  # Custom keybindings
  home.file.".config/yazi/keymap.toml".text = ''
    [mgr]
    prepend_keymap = [   # Higher priority than default keymap
      # Smart enter: enter directories, open files (see https://yazi-rs.github.io/docs/tips/)
      { on = [ "<Enter>" ], run = "plugin smart-enter", desc = "Enter directory / open file" },
      { on = [ "p" ], run = "plugin smart-paste", desc = "Paste into hovered directory or CWD" },

      # Swap default open keys:
      # - `o` opens the "open with" context menu
      # - `O` opens directly with default opener
      { on = [ "o" ], run = "open --interactive", desc = "Open with..." },
      { on = [ "O" ], run = "open", desc = "Open" },
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

  home.file.".config/yazi/plugins/smart-paste.yazi/main.lua".text = ''
    --- @since 25.5.31
    --- @sync entry
    return {
    	entry = function()
    		local h = cx.active.current.hovered
    		if h and h.cha.is_dir then
    			ya.emit("enter", {})
    			ya.emit("paste", {})
    			ya.emit("leave", {})
    		else
    			ya.emit("paste", {})
    		end
    	end,
    }
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
