# OpenCode Headless Server (Multi-Pane Setup)

Read when: setting up opencode in zellij layouts, debugging attach issues.

## Overview

OpenCode supports a headless server mode (`opencode serve`) that allows multiple
TUI clients to attach to the same session via `opencode attach`.

## Commands

| Command | Purpose |
|---|---|
| `opencode serve --port <N>` | Start headless server (no TUI, no web UI) on a fixed port |
| `opencode web --port <N>` | Start server **with** web UI (opens browser) |
| `opencode attach http://localhost:<N>` | Attach a TUI client to a running server |

## Authentication

When binding OpenCode to `0.0.0.0`, set `OPENCODE_SERVER_PASSWORD` so the
server is not exposed without auth.

In this repo, the password is exported from `~/.config/fish/conf.d/90-sops-secrets.fish`.
Zellij server panes started with `fish -c` should explicitly source that file
before running `opencode serve`, because non-interactive Fish startup does not
reliably populate the secret env for the pane command.

Recommended pattern for a network-exposed server pane:

```fish
if test -f ~/.config/fish/conf.d/90-sops-secrets.fish
  source ~/.config/fish/conf.d/90-sops-secrets.fish
end

if test -z "$OPENCODE_SERVER_PASSWORD"
  echo "OPENCODE_SERVER_PASSWORD is not set; refusing to start network-exposed OpenCode server."
  exit 1
end

opencode serve --hostname 0.0.0.0 --port 4096
```

Attached sessions inherit the server working directory by default. In this repo,
the shared Zellij server pane starts from `~/repos` so plain `opencode attach`
lands there unless a client passes `--dir`.

## Zellij Layout (what works)

Three panes in a tab:

1. **Server pane (small, ~5%)** — runs `opencode serve --port 3010` in the foreground.
2. **Attach pane 1** — `sleep 4; opencode attach http://localhost:3010`
3. **Attach pane 2** — `sleep 4; opencode attach http://localhost:3010`

## Known Issues / Gotchas

### `waitForPort` curl loop does not work

A fish loop like:

```fish
while not curl -sf http://localhost:3010 >/dev/null 2>&1; sleep 1; end
```

does **not** reliably gate `opencode attach`. The attach panes end up in a
blank, text-editor-like state where you can type but nothing happens. The server
is confirmed running and the port is open — the issue seems to be that
`opencode serve` does not respond to plain HTTP `GET /` in a way that `curl -sf`
recognises as success, or there is a race between the port being open and the
server being ready to accept attach connections.

**Workaround:** Use a fixed `sleep 4` before `opencode attach`. This is crude
but reliable.

### Backgrounding `opencode serve` in the same pane

Running the server backgrounded in fish (`opencode serve --port 3010 &`) and
then attaching in the same pane works for **that** pane, but a second pane
attaching to the same server remains blank. Reason unclear — possibly related
to the same readiness issue above.

**Recommendation:** Dedicate a small pane to the server process running in the
foreground.

## Port Allocation

Currently using port **3010** for the "ask" tab. If adding more serve-based tabs,
pick a different port per tab to avoid collisions (e.g. 3011, 3012, ...).
