# ./modules/home/helix.nix
{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    settings = {
      theme = "monokai_pro_spectrum";

      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
        cursor-shape.normal = "block";
        cursor-shape.select = "underline";
        auto-pairs = true;
        auto-completion = false;
        idle-timeout = 200;
        color-modes = true;
        true-color = true;
        bufferline = "always";
        soft-wrap.enable = true;
        soft-wrap.max-wrap = 8;

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          center = [ "position-percentage" ];
          right = [ "selections" "diagnostics" "version-control" "register" ];
          mode.normal = "NOR";
          mode.insert = "INS";
          mode.select = "SEL";
        };

        whitespace.render = {
          space = "none";
          tab = "none";
          newline = "none";
        };

        indent-guides.render = true;
        indent-guides.character = "│";
        indent-guides.skip-levels = 1;
      };

      keys.normal.space.space = "file_picker";
      keys.normal.space.w = [ ":w" "write" ];
      keys.normal.space.q = [ ":q" "close" ];
    };

    extraPackages = with pkgs; [
      # Language servers
      nil # Nix
      #rust-analyzer # Rust (commented; install via rustup)
    ];
  };
}
