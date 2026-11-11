{
  pkgs,
  config,
  ...
}: let
  niriConfig = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/.config/niri";
in {
  xdg.configFile."niri" = {
    source = niriConfig;
  };

  home.packages = with pkgs; [
    niri
    xwayland-satellite
  ];

}
