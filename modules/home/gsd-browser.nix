{ pkgs, ... }:

let
  version = "0.1.25";
  system = pkgs.stdenv.hostPlatform.system;

  sources = {
    aarch64-darwin = {
      asset = "gsd-browser-darwin-arm64";
      hash = "sha256-OMbYS43AIdl6FDCEBxrttUR/KRyefuzg3V3+oCtjEZU=";
    };
    x86_64-darwin = {
      asset = "gsd-browser-darwin-x64";
      hash = "sha256-BpBFryIVgc6efUkfRc30hBq8PrWJVIni25hM2GrzvDE=";
    };
    aarch64-linux = {
      asset = "gsd-browser-linux-arm64";
      hash = "sha256-fSHLMlK+ZjqqYbvxGUc6+iUGAmatO7niu6o1pDHXQoo=";
    };
    x86_64-linux = {
      asset = "gsd-browser-linux-x64";
      hash = "sha256-zrCtMhESKH0j6v+vHsmeGFWcNgAjb9KRphh6ZEaVXW8=";
    };
  };

  source = sources.${system} or (throw "gsd-browser is not packaged for ${system}");

  gsd-browser = pkgs.stdenvNoCC.mkDerivation {
    pname = "gsd-browser";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/gsd-build/gsd-browser/releases/download/v${version}/${source.asset}";
      inherit (source) hash;
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $src $out/bin/gsd-browser
      chmod +x $out/bin/gsd-browser

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Terminal-first browser automation CLI";
      homepage = "https://github.com/gsd-build/gsd-browser";
      license = licenses.mit;
      mainProgram = "gsd-browser";
      platforms = builtins.attrNames sources;
    };
  };
in
{
  home.packages = [ gsd-browser ];
}
