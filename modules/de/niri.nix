{ lib, config, pkgs, configDir, ... }:
lib.my.mkModule { inherit config; } "de.niri" "Niri Window Manager" {

  programs.niri.enable = true;
  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  hm.dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Set dark mode on apps that read dconf
      "color-scheme" = "prefer-dark";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    BROWSER = "zen";
  };

  hm.xdg.configFile."niri/config.kdl".source = import (configDir + /niri/niri_config.nix) { inherit lib pkgs config; };
}
