{ pkgs, lib }:
let
  inherit (lib) concatMapStringsSep;
  inherit (lib.strings) concatMapAttrsStringSep;
  inherit (pkgs) writeShellScriptBin;
  secrets = import ./secrets.nix;
  mk-secrets = writeShellScriptBin "mk-secrets" 
    (concatMapAttrsStringSep "\n" (
      file: { script ? "", publicKeys ? [], ... }:
      let
        script-name = "mk-secrets-for-${file}";
        populate-script = writeShellScriptBin script-name script;
      in ''
        ${populate-script}/bin/${script-name} | ${pkgs.rage}/bin/rage ${concatMapStringsSep " " (key: "-r \"${key}\"") publicKeys} -o ${file}
      ''
    ) secrets);
in mk-secrets
