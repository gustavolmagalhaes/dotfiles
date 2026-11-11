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

    graphical.waybar
  ];

  programs.niri.enable = true;
  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

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
