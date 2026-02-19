# /etc/nixos/home/vii/home-linux.nix
# Home Manager configuration for Linux (NixOS)
{ config, pkgs, lib, ... }:

let
  secretsFile = ../../secrets/secrets.yaml;
  haveSecretsFile = builtins.pathExists secretsFile;
in
{
  # Import user specific packages
  imports = [
    ./git.nix
    ../../modules/home/pybonsai.nix
  ];

  # Set user and home directory (required on NixOS)
  home.username = "vii";
  home.homeDirectory = "/home/vii";

  # Configure user-level programs
  programs.fish.enable = true;
  programs.direnv.enable = true;

  # Secrets (sops-nix)
  #
  # IMPORTANT: Do not embed secret values in Nix options (they end up in the Nix store).
  # Instead, sops-nix materializes decrypted secret files at activation time, and we export
  # env vars from those files at shell runtime.
  sops = lib.mkIf haveSecretsFile {
    defaultSopsFile = secretsFile;

    # Per-user age key (create via docs/secrets.md)
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      x_api_key = { };
      x_api_key_secret = { };
      claude_api_key = { };
    };
  };

  home.file = lib.mkIf haveSecretsFile {
    ".config/fish/conf.d/90-sops-secrets.fish".text = ''
      # Export secrets via sops-nix managed files (avoid putting values in the Nix store).
      set -gx X_API_KEY (string trim < ${config.sops.secrets.x_api_key.path})
      set -gx X_API_KEY_SECRET (string trim < ${config.sops.secrets.x_api_key_secret.path})
      set -gx CLAUDE_API_KEY (string trim < ${config.sops.secrets.claude_api_key.path})
      set -gx ANTHROPIC_AUTH_TOKEN (string trim < ${config.sops.secrets.claude_api_key.path})
    '';
  };

  # LazyGit theme: selected item background color
  xdg.configFile."lazygit/config.yml".text = ''
    gui:
      theme:
        selectedLineBgColor: ["#FFD3CB"]
  '';

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Ensures configuration doesn't break on updates. Keep version static after first config.
  # You can update Home Manager without changing this value. See the Home Manager release
  # notes for a list of state version changes in each release.
  home.stateVersion = "25.05";   
}
