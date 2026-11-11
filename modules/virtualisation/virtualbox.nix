# VirtualBox guest integration
{ pkgs, ... }:
{
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
}
