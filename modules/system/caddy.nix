{ config, pkgs, ... }:

let
  lanHttpsRule = "-s 192.168.0.0/24 -d 192.168.0.3 -p tcp --dport 443 -j nixos-fw-accept";
in
{
  sops = {
    secrets.HETZNER_API_KEY_DNS_CHALLANGE_CADDY = { };
    templates."caddy.env" = {
      mode = "0400"; # systemd reads this root-only file before starting Caddy.
      restartUnits = [ "caddy.service" ];
      content = ''
        HETZNER_API_TOKEN=${config.sops.placeholder.HETZNER_API_KEY_DNS_CHALLANGE_CADDY}
      '';
    };
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      # v2 uses the Hetzner Cloud DNS API, not the legacy DNS Console API.
      plugins = [ "github.com/caddy-dns/hetzner/v2@v2.0.0" ];
      hash = "sha256-EseUjOQ2wIvI/sHbP5pCFyTLKgfI989i44Mwe0qCikI=";
    };
    environmentFile = config.sops.templates."caddy.env".path;
    openFirewall = false;
    globalConfig = ''
      auto_https disable_redirects
      servers {
        protocols h1 h2
      }
    '';
    virtualHosts."vault.wenninger.io" = {
      logFormat = null; # Avoid recording vault request paths in access logs.
      extraConfig = ''
        tls {
          dns hetzner {env.HETZNER_API_TOKEN}
          propagation_delay 30s
          resolvers 1.1.1.1 8.8.8.8
        }
        respond "Caddy HTTPS is ready. Vaultwarden is not deployed yet." 200
      '';
    };
  };

  systemd.services.caddy = {
    requires = [ "sops-install-secrets.service" ];
    after = [ "sops-install-secrets.service" ];
  };

  networking.firewall = {
    # Only tailnet traffic and IPv4 home-LAN clients can reach HTTPS.
    interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [ 443 ];
    extraCommands = ''
      iptables -A nixos-fw ${lanHttpsRule}
    '';
    extraStopCommands = ''
      iptables -D nixos-fw ${lanHttpsRule} 2>/dev/null || true
    '';
  };
}
