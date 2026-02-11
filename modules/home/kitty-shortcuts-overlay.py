#!/usr/bin/env python3
"""
Kitty shortcuts overlay - Display keyboard shortcuts in an overlay window
Similar to which-key in neovim
"""

from typing import List
from kitty.boss import Boss

# Define your shortcuts here
SHORTCUTS = {
    "Copy/Paste": [
        ("Ctrl+C", "Copy or interrupt"),
        ("Ctrl+V", "Paste from clipboard"),
    ],
    "Tab Management": [
        ("Ctrl+Shift+T", "New tab"),
        ("Ctrl+Shift+Q", "Close tab"),
        ("Alt+L", "Next tab"),
        ("Alt+H", "Previous tab"),
        ("Alt+1-5", "Jump to tab 1-5"),
    ],
    "Window Management": [
        ("Ctrl+Shift+Enter", "New window (same dir)"),
        ("Ctrl+Shift+W", "Close window"),
        ("Ctrl+Shift+Ä", "Next window"),
        ("Ctrl+Shift+Ö", "Previous window"),
        ("Alt+J", "Move to window below"),
        ("Alt+K", "Move to window above"),
    ],
    "Font Size": [
        ("Ctrl+Shift++", "Increase font size"),
        ("Ctrl+Shift+-", "Decrease font size"),
        ("Ctrl+Shift+0", "Reset font size"),
    ],
    "Fish Shell Keybindings": [
        ("Ctrl+L", "Delete whole line"),
        ("Ctrl+S", "Clear screen"),
        ("Ctrl+Right/Left", "Move word-wise"),
        ("Ctrl+B", "Fuzzy search key bindings"),
        ("Ctrl+P", "Fuzzy search processes"),
        ("Ctrl+F", "Fuzzy search directories"),
        ("Ctrl+Y", "Copy command line (insert)"),
        ("yy", "Copy command line (normal)"),
        ("Ctrl+O", "Fuzzy pick file and insert"),
        ("Alt+S", "Prefix command with sudo"),
    ],
    "Help": [
        ("Ctrl+Shift+#", "Show this shortcuts overlay"),
    ],
}


def format_shortcuts() -> str:
    """Format shortcuts as a nice text display"""
    lines = []
    lines.append("╔═══════════════════════════════════════════════════════════════╗")
    lines.append("║           KITTY KEYBOARD SHORTCUTS                            ║")
    lines.append("╠═══════════════════════════════════════════════════════════════╣")

    for category, shortcuts in SHORTCUTS.items():
        lines.append(f"║                                                               ║")
        lines.append(f"║  {category:<59} ║")
        lines.append(f"║  {'─' * 59} ║")

        for key, description in shortcuts:
            # Format: key (left-aligned, 20 chars) | description
            lines.append(f"║  {key:<20} │ {description:<36} ║")

    lines.append(f"║                                                               ║")
    lines.append("╠═══════════════════════════════════════════════════════════════╣")
    lines.append("║  Press any key to close                                       ║")
    lines.append("╚═══════════════════════════════════════════════════════════════╝")

    return "\n".join(lines)


def main(args: List[str]) -> str:
    """Main entry point for the kitten"""
    return format_shortcuts()


# This is called by kitty
handle_result = type('', (), {'no_ui': True})()
