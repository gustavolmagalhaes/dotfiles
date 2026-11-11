{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.ist;
in
{
  options.modules.dev.ist.enable = mkEnableOption "IST Prolog Development Tools";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swi-prolog
      scryer-prolog
    ];
  };
}
