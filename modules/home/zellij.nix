# modules/home/zellij.nix
# Zellij terminal multiplexer configuration (startup layout)
{ pkgs, ... }:

{
  # Needed for standalone Home Manager activation (flake homeConfigurations.work).
  home.packages = [
    pkgs.zellij
  ];

  home.file.".config/zellij/config.kdl".text = ''
    default_layout "startup"
    theme "tokyo-night"
  '';

  home.file.".config/zellij/layouts/startup.kdl".text = ''
    layout {
      tab name="yazi" {
        pane name="default" focus=true
        pane command="yazi"
      }
      tab name="agent1" {
        pane name="agent1" focus=true
        pane name="agent2" command="copilot"
      }
      tab name="editor" {
        pane name="editor" focus=true
        pane name="editor2" command="nvim"
      }
    }
  '';
}
