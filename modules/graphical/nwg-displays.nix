{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.nwg-displays;
in
{
  options.modules.graphical.nwg-displays.enable = mkEnableOption "nwg-displays";

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      nwg-displays
    ];
  };
}
