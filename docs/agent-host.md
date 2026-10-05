# agent-host

Read when: installing the agent VM, managing its boot services, or configuring the Synology mount.

Fresh x86_64 NixOS 26.05 VM on Proxmox, using BIOS boot and /dev/sda,
matching the existing home-server VM. Enable the QEMU Guest Agent option
in Proxmox. Use a unique MAC address and a separate DHCP reservation.

Both server hosts import modules/system/server-tools.nix: Docker 29,
Compose, Codex, OpenCode, Python, uv, Fish, Herdr, Helix, Yazi, and the
existing Home Manager configuration. Ollama is enabled on neither server.
The nixswitch and nixdry abbreviations select the correct server flake output.
The existing home-server hostname is unchanged.

## Generate the VM's hardware configuration

Generate the hardware configuration on the target VM and check its root UUID
against lsblk -f. A disk clone can legitimately retain home-server's UUID;
use the UUID actually present on this VM. Run from the repository root:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/agent-host/hardware-configuration.nix
git add hosts/agent-host/hardware-configuration.nix
nix fmt -- hosts/agent-host/configuration.nix hosts/agent-host/hardware-configuration.nix
nix flake check --no-build --option eval-cache false
sudo nixos-rebuild dry-run --flake .#agent-host --option eval-cache false
sudo nixos-rebuild switch --flake .#agent-host --option eval-cache false
```

The generated file must be staged because Git flakes exclude untracked files.
Commit it after checking the disk layout. Until it exists, evaluating agent-host
intentionally fails with an installation message. Keep system.stateVersion at
the original installation value, even when the running NixOS release is newer.

Before the first build, verify Hermes's Telegram SOPS keys as described below.
Before the first rebuild, provision the user's age key and authorize its public
recipient as described in docs/secrets.md. The shared Home Manager configuration
requires the existing SOPS secrets, and links OpenCode to ~/repos/agent-general;
clone that repository if those OpenCode links are needed. Preserve a working SSH
login/user credential during installation; this configuration does not provision
new passwords or authorized SSH keys.

## OpenCode boot service

`opencode-server.service` starts at VM boot, without a login or an `ocss` shell.
Both this host and `home-server` import the same OpenCode service through
`modules/system/server-tools.nix`. It runs as `vii` on `0.0.0.0:4096`, with the
password decrypted by system-level SOPS using the provisioned user Age key.
TCP port 4096 is open in this host's firewall for direct mobile/client access at
`http://<agent-host-IP>:4096`, authenticated with `opencode_server_password`
(default username: `opencode`). Use a trusted LAN or VPN: this endpoint is plain
HTTP, so do not forward it to the public internet. The Synology password is a
separate credential. See
[OpenCode boot services](opencode-server.md#server-vm-boot-services) for prerequisites,
direct access, optional SSH tunnelling, and service checks. Do not also run `ocss`
on this host.

## Synology SMB boot mount

At boot, agent-host attempts to mount `//192.168.0.200/home-server-share` at
`/mnt/home-server-share`, using Synology account `agent-host-user`. Network and
system-level SOPS must be ready first; no user login is required. This is an
immediate boot mount, not a first-access automount. If the NAS is unavailable,
the mount attempt has a 30-second timeout without blocking VM startup (waiting
for prerequisite services is separate). Once the NAS returns, retry with
`sudo systemctl start 'mnt-home\x2dserver\x2dshare.mount'`.

Before rebuilding, add the real password to `secrets/secrets.yaml` under the
exact key `synology-home-server-share-pw`. From the repository root, open the
encrypted file with SOPS and add the key in the editor; do not put the password
in a shell command, Nix configuration, or an unencrypted file:

```fish
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" EDITOR=hx sops secrets/secrets.yaml
```

SOPS renders a root-only (0400) CIFS credentials file at boot; the password does
not enter the Nix store. The VM needs the authorized age identity described
above. Unix extensions are disabled so local files and directories are mapped
to `vii` and the `home-server-share` group, with modes 0660/0770. Both `vii` and
`hermes` belong to this group; the NAS account's permissions still apply.
Hermes's service sandbox permits writes at `/mnt/home-server-share`.
No extra inbound firewall port is needed. SMB dialect negotiation uses the
client's default.

After rebuilding, verify the mount and repeat after reboot:

```fish
sudo systemctl status 'mnt-home\x2dserver\x2dshare.mount'
findmnt --mountpoint /mnt/home-server-share
sudo journalctl -u 'mnt-home\x2dserver\x2dshare.mount' -b
sudo -u vii ls /mnt/home-server-share
sudo -u hermes ls /mnt/home-server-share
```

After changing mount ownership or modes, restart the mount to apply the new CIFS
options. Restart Hermes to pick up group membership and sandbox changes:

```fish
sudo systemctl restart 'mnt-home\x2dserver\x2dshare.mount'
sudo systemctl restart hermes-agent.service
sudo -u hermes sh -c 'printf "# Hermes SMB write test\n" > /mnt/home-server-share/hermes-smb-test.md'
sudo -u hermes cat /mnt/home-server-share/hermes-smb-test.md
```

Changing SOPS data can restart the secret installation service during activation
and interrupt its dependent mount. Stop workloads using the share before such a
rebuild. After activation, verify the mount; to reconnect with updated credentials,
run:

```fish
sudo systemctl restart 'mnt-home\x2dserver\x2dshare.mount'
```

## Native Hermes installation

This host imports Hermes's official NixOS module and explicitly disables its
container mode. Docker stays available for workloads and agent development.
Hermes is pinned to upstream revision 8b66a51036c1e20920a17cdd049fdf55c968d683
in flake.nix. This is an inspected revision, not a tested build. Hermes uses its
own upstream nixpkgs input; it does not follow this repository's stable nixpkgs,
because the runtime Python family and build dependencies follow upstream pins.

Official references checked on 2026-10-04:

- https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup
- https://github.com/NousResearch/hermes-agent/blob/8b66a51036c1e20920a17cdd049fdf55c968d683/nix/nixosModules.nix

Upstream documents native Nix packages/modules as best-effort. Updates are
intentional changes to the pinned revision, followed by Nix checks and a rebuild.
No FHS environment or Hermes Docker image is used.

## Provider and messaging configuration

### Telegram credentials in SOPS

From the repository root, open the encrypted file:

```bash
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" sops secrets/secrets.yaml
```

The encrypted repository file already contains both keys. When provisioning
another bot, update these top-level entries in the editor, using its token from
@BotFather and your numeric Telegram user ID. Keep both values quoted strings:

```yaml
HERMES_TELEGRAM_BOT_TOKEN: "your-bot-token"
HERMES_TELEGRAM_ALLOWED_USERS: "your-numeric-user-id"
```

For multiple allowed users, use a comma-separated string of numeric IDs. Save
and close; SOPS encrypts the values in secrets/secrets.yaml. These entries must
exist before building because sops-nix validates the declared keys.

The NixOS SOPS module reuses the provisioned user age key and decrypts at boot.
It renders /run/secrets/rendered/hermes-telegram.env, readable only by the Hermes
service account and root, mapping the prefixed SOPS names to TELEGRAM_BOT_TOKEN
and TELEGRAM_ALLOWED_USERS. SOPS links this file at /var/lib/hermes/.hermes/.env;
Hermes waits for sops-install-secrets.service before starting. The upstream
environmentFiles option is deliberately unused because it reads files during
activation, before boot-time SOPS has rendered them. Secret changes request a
Hermes service restart on switch. There is no manually maintained
/var/lib/hermes/provider.env anymore.

### ChatGPT subscription authentication

Subscription login is separate from Telegram credentials. After Hermes is
installed, authenticate as the service account:

```bash
sudo -u hermes env HERMES_HOME=/var/lib/hermes/.hermes hermes auth add openai-codex
```

Open the displayed URL on your laptop or phone and approve the device code using
your OpenAI account. Hermes stores and refreshes the credentials in
/var/lib/hermes/.hermes/auth.json. No OpenAI API key is required for this route;
do not put your ChatGPT password or manually copied OAuth tokens in the SOPS file.

Set the provider/model and any non-secret gateway options under
services.hermes-agent.settings in hosts/agent-host/configuration.nix. This host
selects model.provider = "openai-codex" for ChatGPT subscription authentication
and model.default = "gpt-6.1-sol" for Sol 6.1. The pinned Hermes source lists this
model ID in its OpenAI API catalog; availability through the Codex subscription
backend depends on the authenticated account's live model catalog. Do not enable
a public API/dashboard unless its authentication and access have been configured.

The native NixOS module owns configuration and startup. Do not run hermes setup,
hermes config set, hermes gateway setup/install, or hermes update to replace the
managed configuration, create a second service, or change the package in place.
Edit the Nix settings/runtime credentials and rebuild instead.

## Service and state

The module creates the hermes user and hermes-agent.service, starts it at boot,
and enables lingering for its scheduler's user bus. Its default paths are:

| Purpose | Path |
|---|---|
| State parent | /var/lib/hermes |
| HERMES_HOME: config, credentials, memory, skills, sessions | /var/lib/hermes/.hermes |
| Agent workspace | /var/lib/hermes/workspace |

The host hermes CLI points to the same HERMES_HOME. Use the service account for
interactive administration so state files retain the correct ownership:

```bash
sudo -u hermes env HERMES_HOME=/var/lib/hermes/.hermes hermes doctor
sudo -u hermes env HERMES_HOME=/var/lib/hermes/.hermes hermes chat
sudo systemctl status hermes-agent.service
sudo journalctl -u hermes-agent.service -f
```

The service explicitly receives Codex, OpenCode, Python, uv, Node, Bun, Git,
and Docker tools through extraPackages. The hermes user joins the Docker group
so it can use the dedicated VM's Docker engine. Docker group access grants
control over this VM, including root-equivalent access through containers.
The service otherwise uses the upstream module's native hardening and writable
workspace; it is not configured to write freely across /home/vii.

After editing the Telegram SOPS entries, rebuild/switch to update Hermes's
SOPS-managed .env and restart the gateway. Back up /var/lib/hermes, including
credentials, and keep the backup private. To update Hermes, replace the input revision in flake.nix, run
nix flake lock, validate the build, and activate. Do not modify /nix/store or use
pip to repair the packaged Hermes environment. Optional Python dependencies
belong in extraDependencyGroups/extraPythonPackages, as documented upstream.

## Validation status

Hermes and its transitive inputs are pinned in flake.lock. The generated hardware
configuration matches the cloned VM's /dev/sda1 root filesystem, and the live
NetworkManager connection uses DHCP at 192.168.0.4. Formatting, the Linux flake
check, and the agent-host rebuild dry-run passed on 2026-10-04 after merging the
boot-time SOPS integration. The dry-run planned 1,334 derivations and about
940 MiB of cached downloads. An actual build and activation have not been
performed. A dry-run does not verify that Hermes builds or starts successfully.
Both HERMES_TELEGRAM_* keys are present in the encrypted secrets file. The SOPS age key decrypts the
configured secrets, but ~/repos/agent-general is absent, so the OpenCode config
links need that repository.
After switching, perform the doctor and service checks above on agent-host.
