{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "de.fonts" "Fonts" {
  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    material-design-icons
    nerd-fonts.jetbrains-mono
  ];
}
