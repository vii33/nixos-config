# OpenCode TUI Shortcuts

Read when: navigating OpenCode messages, configuring `tui.jsonc`, or updating the keybindings TUI.

OpenCode runs inside Herdr, so Ghostty scrollback shortcuts do not scroll its messages.
Custom bindings live in `~/repos/agent-general/opencode/tui.jsonc` (linked from
`~/.config/opencode/tui.jsonc`). Other bindings below are OpenCode v1.18.32 defaults:
[keybind reference](https://github.com/anomalyco/opencode/blob/v1.18.32/packages/web/src/content/docs/keybinds.mdx).

| Action | Key(s) | Source |
|---|---|---|
| Scroll messages one line down/up | `Ctrl + J` / `Ctrl + K` | Custom |
| Scroll messages half-page down/up | `Ctrl + D` / `Ctrl + U` | Custom |
| Scroll messages full page down/up | `Page Down` / `Page Up` | Default |
| Jump to first message (top) | `Ctrl + G` / `Home` | Default |
| Jump to last message (bottom) | `Ctrl + Shift + G` / `Ctrl + Alt + G` / `End` | Custom (`Ctrl + Shift + G`); other keys retained |
| Show session timeline | `Ctrl + X`, then `G` | Default |

`Ctrl + G` is one chord, not `Ctrl + G` twice. OpenCode has configurable
`messages_previous`, `messages_next`, and `messages_last_user` actions, but all
three default to `none` here. `messages_last_user` jumps to the latest user
message, **not** the previous user message relative to the current position.
The session timeline (`Ctrl + X`, then `G`) is a useful alternative for jumping
between turns without adding new bindings.
