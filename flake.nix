{
  description = "fantascene-dynamic-wallpaper";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        appImageName = "fantascene-dynamic-wallpaper.AppImage";

        appPackage = pkgs.stdenv.mkDerivation {
          pname = "fantascene-dynamic-wallpaper";
          version = "2.0.3";

          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildInputs = [ pkgs.appimage-run ];

          src = ./.;

          dontUnpack = true;
          dontPatchELF = true;
          dontStrip = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 755 $src/${appImageName} $out/bin/${appImageName}
            makeWrapper ${pkgs.appimage-run}/bin/appimage-run $out/bin/fantascene-dynamic-wallpaper \
              --add-flags "$out/bin/${appImageName}"
          '';
        };
      in
      {
        packages.default = appPackage;

        apps.default = {
          type = "app";
          program = "${appPackage}/bin/fantascene-dynamic-wallpaper";
        };
      }
    );
}
