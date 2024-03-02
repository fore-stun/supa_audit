{ lib, stdenv, postgresql }:

stdenv.mkDerivation {
  name = "supa_audit";

  buildInputs = [ postgresql ];

  src = builtins.path {
    name = "supa_audit";
    path = lib.cleanSource ../../.;
  };

  installPhase = ''
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';
}
