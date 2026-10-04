# agent-host

Cloned x86_64 home-server VM on Proxmox, running NixOS 26.05 with BIOS boot
and /dev/sda. Preserve the original installation's system.stateVersion = "25.05".
Enable the QEMU Guest Agent option in Proxmox. Use a unique MAC address and a
separate DHCP reservation for 192.168.0.4. NetworkManager uses DHCP, so no static
IP is needed in NixOS. The VM's current MAC address is BC:24:11:4B:DB:4F.
Root filesystem auto-resizing is enabled so ext4 uses an expanded VM disk on
the next boot.

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

Before the first activation, prepare Hermes's provider.env as described below.
Before the first rebuild, provision the user's age key and authorize its public
recipient as described in docs/secrets.md. The shared Home Manager configuration
requires the existing SOPS secrets, and links OpenCode to ~/repos/agent-general;
clone that repository if those OpenCode links are needed. Preserve a working SSH
login/user credential during installation; this configuration does not provision
new passwords or authorized SSH keys.

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

Before the first activation, create a private runtime environment file on the VM:

```bash
sudo install -d -m 0700 /var/lib/hermes
sudo install -m 0600 /dev/null /var/lib/hermes/provider.env
sudoedit /var/lib/hermes/provider.env
```

Only create the empty file once: repeating the install command overwrites it.
Enter the chosen provider credentials in KEY=value format, and the desired
messaging platform's tokens/allowed-user settings. For example, an OpenRouter
configuration requires OPENROUTER_API_KEY. Do not put real credentials in Git,
Nix attributes, or a Nix path literal. The environmentFiles value is a string
path: the root activation script reads it on the VM, then writes Hermes's .env.
This file can later be replaced by a SOPS-managed path.

Set the provider/model and any non-secret gateway options under
services.hermes-agent.settings in hosts/agent-host/configuration.nix. For
example, settings.model.default is the provider's model identifier. No provider,
model, or messaging account has been selected on your behalf. Do not enable a
public API/dashboard unless its authentication and access have been configured.

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

Changing provider.env alone does not change Hermes's generated .env: rebuild to
materialize it. Back up /var/lib/hermes, including credentials, and keep the
backup private. To update Hermes, replace the input revision in flake.nix, run
nix flake lock, validate the build, and activate. Do not modify /nix/store or use
pip to repair the packaged Hermes environment. Optional Python dependencies
belong in extraDependencyGroups/extraPythonPackages, as documented upstream.

## Validation status

Hermes and its transitive inputs are pinned in flake.lock. The generated hardware
configuration matches the cloned VM's /dev/sda1 root filesystem, and the live
NetworkManager connection uses DHCP at 192.168.0.4. Formatting, the Linux flake
check, and the agent-host rebuild dry-run passed on 2026-10-04. The final dry-run
planned 1,319 derivations and about 919 MiB of cached downloads; many derivations
are dependency downloads or Python wheel installs. An actual build and activation
have not been performed. A dry-run does not verify that Hermes builds or starts
successfully. Before activation, create /var/lib/hermes/provider.env and provide
the desired credentials. The SOPS age key decrypts the configured secrets, but
~/repos/agent-general is absent, so the OpenCode config links need that repository.
After switching, perform the doctor and service checks above on agent-host.
