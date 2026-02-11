# modules/home/pybonsai.nix
# PyBonsai - Procedural ASCII art tree generator
{ pkgs, ... }:

let
  pybonsai = pkgs.stdenv.mkDerivation {
    pname = "pybonsai";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "Ben-Edwards44";
      repo = "PyBonsai";
      rev = "main";
      sha256 = "sha256-lq11e0RDyXDfBhfMcuywmCFMPie+AihlJT5SUwZGxUs=";
    };

    buildInputs = [ pkgs.python3 ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/pybonsai

      # Copy all Python files to share directory
      cp -r *.py $out/share/pybonsai/

      # Create wrapper script
      cat > $out/bin/pybonsai <<EOF
#!/bin/sh
exec ${pkgs.python3}/bin/python3 $out/share/pybonsai/main.py "\$@"
EOF

      chmod +x $out/bin/pybonsai
    '';

    meta = with pkgs.lib; {
      description = "Procedural ASCII art tree generator for the terminal";
      homepage = "https://github.com/Ben-Edwards44/PyBonsai";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in
{
  home.packages = [ pybonsai ];
}
