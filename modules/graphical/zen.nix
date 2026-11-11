{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.zen;
in
{
  options.modules.graphical.zen.enable = mkEnableOption "Zen Browser";

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      inputs.zen-browser.homeModules.default
    ];

    hm.programs.zen-browser.enable = true;
  };
}
