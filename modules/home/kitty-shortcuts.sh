#!/usr/bin/env bash
# Kitty shortcuts overlay - Display keyboard shortcuts
# Similar to which-key in neovim

cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║           KITTY KEYBOARD SHORTCUTS                            ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Copy/Paste                                                   ║
║  ───────────────────────────────────────────────────────────  ║
║  Ctrl+C              │ Copy or interrupt                      ║
║  Ctrl+V              │ Paste from clipboard                   ║
║                                                               ║
║  Tab Management                                               ║
║  ───────────────────────────────────────────────────────────  ║
║  Ctrl+Shift+T        │ New tab                                ║
║  Ctrl+Shift+Q        │ Close tab                              ║
║  Alt+T               │ New tab                                ║
║  Alt+W               │ Close tab                              ║
║  Alt+L               │ Next tab                               ║
║  Alt+H               │ Previous tab                           ║
║  Alt+1-5             │ Jump to tab 1-5                        ║
║                                                               ║
║  Window Management                                            ║
║  ───────────────────────────────────────────────────────────  ║
║  Ctrl+Shift+Enter    │ New window (same dir)                  ║
║  Ctrl+Shift+W        │ Close window                           ║
║  Ctrl+Shift+Ä        │ Next window                            ║
║  Ctrl+Shift+Ö        │ Previous window                        ║
║  Alt+J               │ Move to window below                   ║
║  Alt+K               │ Move to window above                   ║
║                                                               ║
║  Font Size                                                    ║
║  ───────────────────────────────────────────────────────────  ║
║  Ctrl+Shift++        │ Increase font size                     ║
║  Ctrl+Shift+-        │ Decrease font size                     ║
║  Ctrl+Shift+0        │ Reset font size                        ║
║                                                               ║
║  Fish Shell Keybindings                                       ║
║  ───────────────────────────────────────────────────────────  ║
║  Ctrl+L              │ Delete whole line                      ║
║  Ctrl+S              │ Clear screen                           ║
║  Ctrl+Right/Left     │ Move word-wise                         ║
║  Ctrl+B              │ Fuzzy search key bindings              ║
║  Ctrl+P              │ Fuzzy search processes                 ║
║  Ctrl+F              │ Fuzzy search directories               ║
║  Ctrl+Y              │ Copy command line (insert)             ║
║  yy                  │ Copy command line (normal)             ║
║  Ctrl+O              │ Fuzzy pick file and insert             ║
║  Alt+S               │ Prefix command with sudo               ║
║                                                               ║
║  Help                                                         ║
║  ───────────────────────────────────────────────────────────  ║
║  Ctrl+Shift+#        │ Show this shortcuts overlay            ║
║                                                               ║
╠═══════════════════════════════════════════════════════════════╣
║  Press any key to close                                       ║
╚═══════════════════════════════════════════════════════════════╝
EOF

# Wait for user input before closing
read -n 1 -s
