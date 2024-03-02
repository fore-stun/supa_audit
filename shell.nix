{ pkgs ? (builtins.fetchTarball {
    name = "2023-11";
    url = "https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz";
  }).pkgs
}:

let
  # Postgresql with supa_audit extension
  pgWithExt = pg: pg.withPackages (_: [
    (pkgs.callPackage ./nix/supa_audit { postgresql = pg; })
  ]);

  # Audit package
  supaAuditScript =
    # Postgresql version, as a string
    pgVersion: assert builtins.isString pgVersion;

    pkgs.callPackage ./nix/supa_audit/pgScript.nix {
      postgresql = pgWithExt pkgs."postgresql_${pgVersion}";
    };

in
pkgs.mkShell {
  buildInputs = builtins.map supaAuditScript [
    "16"
    "15"
    "14"
    "13"
    "12"
  ];
}
