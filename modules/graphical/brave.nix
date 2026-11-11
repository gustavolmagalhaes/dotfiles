{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.brave;
in
{
  options.modules.graphical.brave.enable = mkEnableOption "Brave Browser";

  config = mkIf cfg.enable {
    hm.programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };
  };
}
