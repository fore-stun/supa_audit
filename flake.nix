{
  description = "Generic Table Auditing";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e";
  };

  outputs = { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      foldMap = f:
        builtins.foldl' (acc: x: lib.recursiveUpdate acc (f x)) { };

    in
    lib.flip foldMap lib.systems.flakeExposed (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.${system}.default = import ./shell.nix {
          inherit pkgs;
        };
      });
}
