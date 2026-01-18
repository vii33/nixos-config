# modules/home/yazi.nix
# Yazi terminal file manager configuration
{ config, pkgs, ... }:

let
  kanagawaFlavor = pkgs.fetchFromGitHub {
    owner = "dangooddd";
    repo = "kanagawa.yazi";
    rev = "76d08b0295149c12e15d1cf1bc1d7f21ec49be0f";
    sha256 = "sha256-kMohyRUj/d5ProN+uoiyl2EM8qkOYDwI2YZFdNQ/uq8=";
  };
in
{
  # Yazi is installed system-wide, we just configure it here
  
  # Install the Kanagawa flavor
  home.file.".config/yazi/flavors/kanagawa.yazi" = {
    source = kanagawaFlavor;
  };
  
  # Configure Yazi settings
  home.file.".config/yazi/yazi.toml".text = ''
    [manager]
    show_hidden = false
    sort_by = "natural"
    sort_sensitive = false
    sort_reverse = false
    sort_dir_first = true

    [preview]
    tab_size = 2
    max_width = 600
    max_height = 900
  '';
  
  # Configure Yazi to use the Kanagawa theme
  home.file.".config/yazi/theme.toml".text = ''
    [flavor]
    use = "kanagawa"
  '';
}
