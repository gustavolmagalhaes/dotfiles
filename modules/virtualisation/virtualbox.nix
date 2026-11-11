{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.virtualisation.virtualbox;
in
{
  options.modules.virtualisation.virtualbox.enable = mkEnableOption "VirtualBox Guest Integration";

  config = mkIf cfg.enable {
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.clipboard = true;

    environment.systemPackages = with pkgs; [
      mesa-demos
    ];

    environment.variables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
      MESA_GL_VERSION_OVERRIDE = "4.3";
      ZED_ALLOW_EMULATED_GPU = "1";
    };
  };
}
