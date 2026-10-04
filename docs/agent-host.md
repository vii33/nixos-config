# agent-host

Fresh x86_64 NixOS 26.05 VM on Proxmox, using BIOS boot and /dev/sda,
matching the existing home-server VM. Enable the QEMU Guest Agent option
in Proxmox. Use a unique MAC address and a separate DHCP reservation.

Both server hosts import modules/system/server-tools.nix: Docker 29,
Compose, Codex, OpenCode, Python, uv, Fish, Herdr, Helix, Yazi, and the
existing Home Manager configuration. Ollama is enabled on neither server.
The nixswitch and nixdry abbreviations select the correct server flake output.
The existing home-server hostname is unchanged.

## Generate the fresh VM's hardware configuration

Do not copy the home-server filesystem UUID. After installing NixOS 26.05
and cloning this repository on the new VM, run from the repository root:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/agent-host/hardware-configuration.nix
git add hosts/agent-host/hardware-configuration.nix
nix fmt -- hosts/agent-host/default.nix hosts/agent-host/configuration.nix hosts/agent-host/hardware-configuration.nix hosts/home-server/default.nix modules/system/server-tools.nix flake.nix
nix flake check --no-build
sudo nixos-rebuild dry-run --flake .#agent-host
sudo nixos-rebuild switch --flake .#agent-host
```

The generated file must be staged because Git flakes exclude untracked files.
Commit it after checking the disk layout. Until it exists, evaluating agent-host
intentionally fails with an installation message; the draft PR cannot pass its
full flake check yet. If the installed release differs from 26.05, retain the
system.stateVersion from that fresh installation instead of guessing.

Before the first rebuild, provision the user's age key and authorize its public
recipient as described in docs/secrets.md. The shared Home Manager configuration
requires the existing SOPS secrets, and links OpenCode to ~/repos/agent-general;
clone that repository if those OpenCode links are needed. Preserve a working SSH
login/user credential during installation; this configuration does not provision
new passwords or authorized SSH keys.

## Hermes installation choice

Official references checked on 2026-10-04:

- https://hermes-agent.nousresearch.com/docs/getting-started/installation
- https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup
- https://hermes-agent.nousresearch.com/docs/user-guide/docker
- https://hermes-agent.nousresearch.com/docs/user-guide/messaging

The standard Linux source installation uses the installer followed by Hermes
setup. Its native Linux gateway defaults to a user systemd service; the manual
recommends a system service for headless hosts. The Nix guide explicitly calls
native Nix packages/modules best-effort and recommends Docker or an FHS
environment for a supported setup. This host therefore uses the official Docker
stable image, managed by NixOS's OCI-container systemd unit, docker-hermes.service.
Do not run hermes gateway install inside this container or create a second gateway.

## One-time Hermes setup

The service is enabled at boot, but skips startup until config.yaml exists.
After activating the host configuration, configure Hermes over SSH:

```bash
sudo docker run -it --rm -v /var/lib/hermes:/opt/data nousresearch/hermes-agent:stable setup
sudo systemctl start docker-hermes.service
sudo docker exec -it hermes hermes doctor
sudo systemctl status docker-hermes.service
sudo docker logs --tail 100 hermes
```

Select the desired provider/model and messaging platform in the wizard. Credentials
are written into /var/lib/hermes/.env at runtime, outside Git and the Nix store.
Treat /var/lib/hermes as the persistent state: it holds config, credentials,
sessions, memory, skills, and scheduled jobs. Back it up on the VM's native disk.
Stop the gateway before running another setup wizard against the same data.

No gateway API/dashboard port or Docker socket is exposed to the Hermes container.
Messaging platforms use outbound connections. Add authenticated API/dashboard
access explicitly if required later. Docker is available on the host, but host
Codex/Python/uv tools are not automatically available inside the Hermes image;
container tools follow the official image contents. Additional tools should be
installed in a derived image or accessed through deliberately configured services.

## Updates and operation

```bash
sudo docker exec -it hermes hermes
sudo docker exec hermes hermes gateway status
sudo systemctl stop docker-hermes.service
sudo docker pull nousresearch/hermes-agent:stable
sudo systemctl start docker-hermes.service
```

The stable tag tracks stable releases. For exact reproducibility, replace it in
configuration.nix with a tested image digest, and use that same image for setup.
Do not use hermes update to mutate the installed container application.
NixOS owns the container lifecycle; the image's supervisor owns the gateway
process. The Proxmox VM has not been installed or activated by this PR.

## Validation status

Nix, nixfmt, Docker, and access to the target Proxmox VM were unavailable in the
editing environment. Run the formatting, flake check, and host dry-run commands
above after adding the real hardware file; also dry-run home-server because its
tools were extracted into the shared module. Runtime image/startup validation
must take place on agent-host after provider and messaging setup.
