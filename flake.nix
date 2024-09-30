{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nix-deno.url = "github:nekowinston/nix-deno";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [inputs.nix-deno.overlays.default];
      };
    in {
      packages.example-executable = pkgs.denoPlatform.mkDenoBinary {
        name = "example-executable";
        version = "0.1.2";
        src = ./.;
        buildInputs = []; # other dependencies
        permissions.allow.all = true;
      };
      defaultPackage = self.packages.${system}.example-executable;
    });
}
