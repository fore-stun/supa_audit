{ pkgs ? (builtins.fetchTarball {
    name = "2023-11";
    url = "https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz";
  }).pkgs
}:

pkgs.mkShell {
  buildInputs =
    let
      pgWithExt = { pg }: pg.withPackages (p: [ (pkgs.callPackage ./nix/supa_audit { postgresql = pg; }) ]);
      pg_16_w_supa_audit = pkgs.callPackage ./nix/supa_audit/pgScript.nix { postgresql = pgWithExt { pg = pkgs.postgresql_16; }; };
      pg_15_w_supa_audit = pkgs.callPackage ./nix/supa_audit/pgScript.nix { postgresql = pgWithExt { pg = pkgs.postgresql_15; }; };
      pg_14_w_supa_audit = pkgs.callPackage ./nix/supa_audit/pgScript.nix { postgresql = pgWithExt { pg = pkgs.postgresql_14; }; };
      pg_13_w_supa_audit = pkgs.callPackage ./nix/supa_audit/pgScript.nix { postgresql = pgWithExt { pg = pkgs.postgresql_13; }; };
      pg_12_w_supa_audit = pkgs.callPackage ./nix/supa_audit/pgScript.nix { postgresql = pgWithExt { pg = pkgs.postgresql_12; }; };
    in
    [ pg_16_w_supa_audit pg_15_w_supa_audit pg_14_w_supa_audit pg_13_w_supa_audit pg_12_w_supa_audit ];
}
