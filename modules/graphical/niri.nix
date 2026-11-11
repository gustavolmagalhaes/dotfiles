{
  config,
  lib,
  pkgs,
  configDir,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.niri;
in
{
  options.modules.graphical.niri.enable = mkEnableOption "Niri Wayland Compositor";

  config = mkIf cfg.enable {
    programs.niri.enable = true;
    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    hm.xdg.configFile."niri".source = "${configDir}/niri";

    # hm.xdg.configFile."niri/config.kdl".source = "${configDir}/niri/config.kdl";
    # hm.xdg.configFile."niri/monitor.kdl".source = "${configDir}/niri/monitor.kdl";
    # hm.xdg.configFile."niri/noctalia.kdl".source = "${configDir}/niri/noctalia.kdl";
  };
}
