{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    material-design-icons
    nerd-fonts.jetbrains-mono
  ];
}
