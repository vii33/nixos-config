# OpenCode Headless Server (Multi-Pane Setup)

Read when: setting up OpenCode in Zellij, managing server VM boot services,
or debugging attach issues.

## Overview

OpenCode supports a headless server mode (`opencode serve`) that allows multiple
TUI clients to attach to the same session via `opencode attach`.

On `agent-host` and `home-server`, `opencode-server.service` starts at boot as `vii`
on `0.0.0.0:4096`, with its password delivered from system-level SOPS. It does not
need the Fish secret export below. TCP port 4096 is open on `agent-host` for
direct client access; it remains closed on `home-server`.
Do not run `ocss` alongside this service on the same port.

## Server VM boot services

Both server hosts import `modules/system/opencode-server.nix` through their shared
`server-tools.nix`. The service starts without a login, uses the user's existing
OpenCode config/auth and installed tools, and starts in their home directory.
Attach with `--dir` to select a project directory on the VM. Provider authentication
still needs to be set up for this user; the server password is not a provider credential.

System-level SOPS decrypts `opencode_server_password` from `secrets/secrets.yaml`
at boot using `~/.config/sops/age/keys.txt`. Provision this key on each VM before
activation and keep it available after reboot. systemd delivers the root-only
secret through `LoadCredential`; the launcher exports the password only at runtime
and refuses an empty value. Missing/decryption-failed secrets prevent startup,
and a changed SOPS password restarts the service on activation. The service does
not depend on Home Manager's login-time secret loading.

### Direct mobile/client access on agent-host

Connect to `http://<agent-host-IP>:4096` from a client on the trusted LAN or VPN.
Use HTTP Basic authentication with username `opencode` and the SOPS
`opencode_server_password` value, **not** the Synology share password. TCP 4096 is
opened only in agent-host's NixOS firewall; any Proxmox/network firewall must
also permit the connection. Hostname `agent-host` works only if the client can
resolve it.

This is plain HTTP: credentials and traffic are not TLS-encrypted. Do not forward
port 4096 to the public internet. For access outside the LAN, use a VPN or an
authenticated HTTPS reverse proxy. The boot service still runs `opencode serve`
(headless API); opening the port does not add the `opencode web` browser UI.

From another device with curl, verify authentication without putting the password
in shell history (the second command prompts for it):

```fish
curl -i http://agent-host:4096/global/health
curl -i --user opencode http://agent-host:4096/global/health
```

The first request must return HTTP 401; the authenticated request should succeed.
Substitute the VM's actual IP if its hostname does not resolve.

### Optional SSH tunnel

On `home-server`, TCP 4096 remains closed in the NixOS firewall. Use an SSH tunnel
there; tunnelling is also an option on agent-host:

```bash
ssh -N -L 4096:127.0.0.1:4096 vii@agent-host
# For home-server, substitute its actual SSH address (its hostname remains nixos).
```

Then run `oca`/`occ` locally (using the same SOPS password), or attach explicitly
with `opencode attach http://localhost:4096 --password "$OPENCODE_SERVER_PASSWORD"`
and a `--dir` path that exists on the VM. If the local port is occupied, choose a
different local tunnel port and use it in the attach URL.

On the target VM, dry-run and activate the corresponding flake output:

```bash
sudo nixos-rebuild dry-run --flake .#home-server --option eval-cache false
sudo nixos-rebuild switch --flake .#home-server --option eval-cache false
```

Use `.#agent-host` instead for that VM, after generating its hardware configuration.
After activation, check the service and repeat after reboot without an interactive
VM shell login:

```bash
sudo systemctl status opencode-server.service
sudo journalctl -u opencode-server.service -f
sudo systemctl restart opencode-server.service
```

Verify an unauthenticated request to `/global/health` returns HTTP 401 and an
authenticated request succeeds before using the server. Manage these instances
with systemctl, not foreground `ocss` processes. The service restarts after crashes.

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

For shell-driven attach workflows, prefer passing the password explicitly via
`opencode attach -p "$OPENCODE_SERVER_PASSWORD" ...`. The `occ` fish
abbreviation does this and also passes `--dir "$PWD"` so the attached client
starts in the current project instead of the server pane's default directory.

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
