{ config, pkgs, lib, ... }:

let
  # Get the lua-specs directory path
  specsDir = ./lua-specs;
  
  # LazyVim expects plugins in ~/.config/nvim/lua/plugins/
  # We'll create individual symlinks for each spec file
  
  # List all .lua files in lua-specs directory
  # Exclude mason-disabled.lua on Darwin (it's only needed on NixOS)
  isDarwin = pkgs.stdenv.isDarwin;
  
  # Get all lua files in the specs directory
  specFiles = builtins.attrNames (builtins.readDir specsDir);
  
  # Filter out mason-disabled.lua on Darwin
  filteredSpecFiles = builtins.filter (name: 
    if isDarwin then name != "mason-disabled.lua" else true
  ) specFiles;
  
  # Create symlinks for each spec file
  mkSpecSymlinks = files: lib.listToAttrs (map (file: {
    name = ".config/nvim/lua/plugins/${file}";
    value = {
      source = "${specsDir}/${file}";
    };
  }) files);
in
{
  # Create symlinks for LazyVim plugin specs
  # LazyVim will automatically load plugins from ~/.config/nvim/lua/plugins/
  home.file = mkSpecSymlinks filteredSpecFiles;
}
