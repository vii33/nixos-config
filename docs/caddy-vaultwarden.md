# Caddy HTTPS for Vaultwarden

`home-server` imports `modules/system/caddy.nix`. Caddy runs natively on NixOS;
Vaultwarden will run separately in Docker. Other Linux hosts and Darwin are unchanged.
The initial site at `https://vault.wenninger.io` serves only a harmless readiness page.

## Credentials and certificates

- The pinned `caddy-dns/hetzner/v2` plugin uses the **Hetzner Cloud DNS API**.
  The token must have read/write access to the project containing the authoritative zone.
- The existing encrypted `HETZNER_API_KEY_DNS_CHALLANGE_CADDY` key is rendered by
  SOPS into a root-only runtime environment file as `HETZNER_API_TOKEN`.
  Neither the token nor a decrypted environment file is written to the Nix store.
- systemd reads that file for Caddy; SOPS template changes restart the service.
  No shell export is required. Existing boot-time SOPS/age configuration is reused.
- Caddy obtains and renews trusted certificates using DNS-01. Outbound HTTPS and DNS
  are required; inbound HTTP, public router forwarding and Funnel are not.
- Public resolvers are used for challenge checks so later split DNS does not interfere.
- Certificate issuance publishes the hostname in public certificate-transparency logs.

## Network and DNS prerequisites

- Keep `192.168.0.3` reserved for the VM. IPv4 LAN clients in `192.168.0.0/24` may
  reach TCP 443 at that address. TCP 443 is also allowed on the Tailscale interface,
  subject to tailnet policy. No general HTTPS opening or direct IPv6 LAN access is added.
- HTTP redirects and HTTP/3 are disabled; use an explicit `https://` URL.
- LAN DNS must resolve `vault.wenninger.io` to `192.168.0.3`; remote tailnet DNS must
  resolve it to the VM's Tailscale IP (unless LAN subnet routing is separately configured).
  This module does **not** configure DNS records, a LAN DNS server, or Tailscale DNS.
- The FRITZ!Box may need a DNS-rebind exception for this exact hostname when a DNS
  answer contains the private address. Clients using their own encrypted DNS may bypass
  the chosen LAN resolver. Do not change existing mail records or nameservers.
- Tailscale must be activated and enrolled separately. Do not run Tailscale Serve on
  the same HTTPS endpoint. Do not enable public forwarding or Funnel.

## Activate and verify

Follow any outstanding home-server network-incident deployment hold before activation.
From this repository on the VM:

```sh
nixos-rebuild dry-run --flake .#home-server
sudo nixos-rebuild switch --flake .#home-server
systemctl status caddy
sudo journalctl -u caddy --since '10 minutes ago'
```

Before configuring LAN DNS, test from a LAN client (requires a valid issued certificate):

```sh
curl --resolve vault.wenninger.io:443:192.168.0.3 https://vault.wenninger.io
```

Do not use `-k`: certificate trust and hostname verification are part of the test.
Then test normal DNS-based access from both LAN and an approved remote Tailscale client,
reboot persistence, and rejection from unauthorized networks. Do not share unredacted
environment files or diagnostic output that contains credentials.

## Later: deploy Vaultwarden

1. Check that host port 8222 is unused, then publish the container as
   `127.0.0.1:8222:80`, with persistent `/data` and a tested backup/restore procedure.
2. Set Vaultwarden's `DOMAIN=https://vault.wenninger.io` and establish controlled
   account provisioning, registration and admin policies.
3. Replace Caddy's readiness `respond` directive with `reverse_proxy 127.0.0.1:8222`.
   Modern Vaultwarden WebSockets use this same upstream; no legacy port 3012 is needed.
4. Add the new container to Dashy in the Docker repository and test clients/sync before
   migrating the primary vault. Keep the backend inaccessible from LAN/Tailscale directly.
