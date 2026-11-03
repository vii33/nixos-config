# OpenCode TUI Shortcuts

Read when: navigating OpenCode messages, configuring `cli.json` keybinds, or updating the keybindings TUI.

OpenCode runs inside Herdr, so Ghostty scrollback shortcuts do not scroll its messages.
Custom bindings live in the `keybinds` block of `~/repos/agent-general/opencode/cli.json`
(linked from `~/.config/opencode/cli.json`). OpenCode v2 ignores `tui.jsonc` keybinds; it
only reads `cli.json`, using dotted IDs. Other bindings below are OpenCode v2 defaults:
[keybind reference](https://opencode.ai/v2/docs/cli/keybinds).

The custom `Ctrl + J/K/D/U` scroll keys collide with v2 prompt defaults (newline, kill-line,
delete/exit), so `cli.json` also disables or narrows `input.newline`,
`input.delete.to.line.end`, `input.delete.to.line.start`, `input.delete`, `app.exit`,
`session.delete` and `stash.delete`. Consequence: no `Ctrl + U/K` kill-line or `Ctrl + D` exit
in OpenCode (`Shift + Enter` still inserts a newline).

| Action | Key(s) | Source |
|---|---|---|
| Scroll messages one line down/up | `Ctrl + J` / `Ctrl + K` | Custom (`session.line.down/up`) |
| Scroll messages half-page down/up | `Ctrl + D` / `Ctrl + U` | Custom (`session.half.page.down/up`) |
| Scroll messages full page down/up | `Page Down` / `Page Up` | Default |
| Jump to first message (top) | `Ctrl + G` / `Home` / `Alt + Home` | Default |
| Jump to last message (bottom) | `Ctrl + Shift + G` / `Ctrl + Alt + G` / `End` | Custom (`session.last`); other keys retained |
| Show session timeline | `Ctrl + X`, then `G` | Default |

`Ctrl + G` is one chord, not `Ctrl + G` twice. OpenCode has configurable
`session.message.previous/next` and `session.message.user.previous/next` actions, all
defaulting to `none`. `session.messages_last_user` (`Alt + End`) jumps to the latest user
message, **not** the previous user message relative to the current position.
The session timeline (`Ctrl + X`, then `G`) is a useful alternative for jumping
between turns without adding new bindings.
