{ config, pkgs, ... }:

{
  # xresources.properties = {
  #   "Xcursor.size" = 4;
  #   "Xft.dpi" = 172;
  # };

  imports = [
    ../modules/home-manager
  ];

  # environment.variables.FILE_MANAGER = "$TERM -e nnn";

  home.packages = with pkgs; [
    fastfetch
    nnn

    dnsutils
    nix-output-monitor
    btop
    pciutils
    usbutils

    zed-editor
    # fuzzel
  ];

  services.gnome-keyring.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Gustavo Magalhães";
      email = "g.lobomagalhaes@gmail.com";
    };
  };


  home.stateVersion = "26.05";
}
