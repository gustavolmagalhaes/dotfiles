{
  config,
  pkgs,
  configDir,
  profiles,
  ...
}:{
  imports = with profiles; [
    graphical.fuzzel
    graphical.alacritty
    graphical.dunst
    graphical.nwg-displays
    graphical.ghostty
    graphical.seahorse
    graphical.zen
    graphical.fonts

    graphical.cliphist

    graphical.waybar
    graphical.nautilus
  ];

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

  services.gnome.gnome-keyring.enable = true;
  hm.services.gnome-keyring.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    BROWSER = "zen";
  };

  # Link the niri config directory from the repo's config/ folder
  hm.xdg.configFile."niri".source = "${configDir}/niri";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

}
